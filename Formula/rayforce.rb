# Homebrew formula TEMPLATE for the rayforcedb/tap tap.
#
# release.yml substitutes https://github.com/RayforceDB/rayforce/archive/refs/tags/v2.5.10.tar.gz and c0ff4b42928b027876c0592e1230f1387f4c5e5ae077037ca1b5e8c9481e2aad (the GitHub source tarball for
# the tag and its sha256) and pushes the result to RayforceDB/homebrew-tap as
# Formula/rayforce.rb on every release.
#
# Build-from-source on purpose: it compiles for the user's own CPU (so it works
# on every Mac arch and never SIGILLs the way a redistributed -march=native
# binary can), and a zero-dependency `make` build needs no `depends_on`.
class Rayforce < Formula
  desc "Embeddable columnar analytics and graph traversal engine in pure C"
  homepage "https://rayforcedb.com/"
  url "https://github.com/RayforceDB/rayforce/archive/refs/tags/v2.5.10.tar.gz"
  sha256 "c0ff4b42928b027876c0592e1230f1387f4c5e5ae077037ca1b5e8c9481e2aad"
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
