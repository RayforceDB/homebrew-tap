# Homebrew formula TEMPLATE for the rayforcedb/tap tap.
#
# release.yml substitutes https://github.com/RayforceDB/rayforce/archive/refs/tags/v2.6.0.tar.gz and 45b1f03dda5b8c317854ff038866cc41220b15ed088912fcb9f7b82558cf0700 (the GitHub source tarball for
# the tag and its sha256) and pushes the result to RayforceDB/homebrew-tap as
# Formula/rayforce.rb on every release.
#
# Build-from-source on purpose: it compiles for the user's own CPU (so it works
# on every Mac arch and never SIGILLs the way a redistributed -march=native
# binary can), and a zero-dependency `make` build needs no `depends_on`.
class Rayforce < Formula
  desc "Embeddable columnar analytics and graph traversal engine in pure C"
  homepage "https://rayforcedb.com/"
  url "https://github.com/RayforceDB/rayforce/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "45b1f03dda5b8c317854ff038866cc41220b15ed088912fcb9f7b82558cf0700"
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
