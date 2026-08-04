# Homebrew formula TEMPLATE for the rayforcedb/tap tap.
#
# release.yml substitutes https://github.com/RayforceDB/rayforce/archive/refs/tags/v2.5.9.tar.gz and 189837b404a7a90de28b0062123e5a2ce9d2647513245f2972dbe3ca9e6a1d61 (the GitHub source tarball for
# the tag and its sha256) and pushes the result to RayforceDB/homebrew-tap as
# Formula/rayforce.rb on every release.
#
# Build-from-source on purpose: it compiles for the user's own CPU (so it works
# on every Mac arch and never SIGILLs the way a redistributed -march=native
# binary can), and a zero-dependency `make` build needs no `depends_on`.
class Rayforce < Formula
  desc "Embeddable columnar analytics and graph traversal engine in pure C"
  homepage "https://rayforcedb.com/"
  url "https://github.com/RayforceDB/rayforce/archive/refs/tags/v2.5.9.tar.gz"
  sha256 "189837b404a7a90de28b0062123e5a2ce9d2647513245f2972dbe3ca9e6a1d61"
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
