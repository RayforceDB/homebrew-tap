# Homebrew formula TEMPLATE for the rayforcedb/tap tap.
#
# release.yml substitutes https://github.com/RayforceDB/rayforce/archive/refs/tags/v2.5.13.tar.gz and 4bb5b0a3a7744f4b1cb0aeb880e70a831f98382fc76590c4cabb9008472c2912 (the GitHub source tarball for
# the tag and its sha256) and pushes the result to RayforceDB/homebrew-tap as
# Formula/rayforce.rb on every release.
#
# Build-from-source on purpose: it compiles for the user's own CPU (so it works
# on every Mac arch and never SIGILLs the way a redistributed -march=native
# binary can), and a zero-dependency `make` build needs no `depends_on`.
class Rayforce < Formula
  desc "Embeddable columnar analytics and graph traversal engine in pure C"
  homepage "https://rayforcedb.com/"
  url "https://github.com/RayforceDB/rayforce/archive/refs/tags/v2.5.13.tar.gz"
  sha256 "4bb5b0a3a7744f4b1cb0aeb880e70a831f98382fc76590c4cabb9008472c2912"
  license "MIT"
  head "https://github.com/RayforceDB/rayforce.git", branch: "master"

  def install
    # Inject the release version (no .git in a source tarball, so git-describe
    # can't), build optimized for the user's machine, install binary + header.
    system "make", "release", "RAY_VERSION=#{version}"
    bin.install "rayforce"
    include.install "include/rayforce.h"
  end

  test do
    assert_match "usage", shell_output("#{bin}/rayforce --help")
    assert_match version.to_s, pipe_output("#{bin}/rayforce", "(.sys.build)\n")
  end
end
