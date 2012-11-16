From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/6] cifs: fix handling of unc= and prefixpath= mount options
Date: Fri, 16 Nov 2012 12:36:48 -0500
Message-ID: <1353087414-32152-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org,
	almiller_1-/E1597aS9LT10XsdtD+oqA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch fixes up a number of problems with the handling of the unc=
and prefixpath= mount options. In addition to cleaning up some really
awful address parsing code, it fixes a couple of potential memory leaks
and gets the unc= and prefixpath= mount options ready to be deprecated,
and sets us up to be able to just use the contents of the device string
instead.

This should also fix a couple of other problems:

- mounting with a unc= option that contains forward slashes as
  delimiters should now work. This should fix the problem that
  Frederico Sauter reported last week.

- a regression reported by Alex Miller should also be fixed[1]. When
  the new mount option parser was merged, the unc= option was
  inadvertantly made mandatory. Prior to that, the code would try
  to use the contents of the device string to construct a UNC. The
  final patch in this series reinstates that behavior and should
  allow a user to mount without the mount helper

I've tested mounting in several ways and this patchset seems to work
as expected. It could use more testing, so I'd suggest allowing it to
soak in -next for a bit with an eye toward merging it in 3.8.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=50631

Jeff Layton (6):
  cifs: make error on lack of a unc= option more explicit
  cifs: get rid of smb_vol->UNCip and smb_vol->port
  cifs: make convert_delimiter use strchr instead of open-coding it
  cifs: clean up handling of unc= option
  cifs: fix up handling of prefixpath= option
  cifs: parse the device name into UNC and prepath

 fs/cifs/cifsglob.h  |  16 +---
 fs/cifs/cifsproto.h |   4 +-
 fs/cifs/connect.c   | 260 ++++++++++++++++++++++++++++------------------------
 fs/cifs/netmisc.c   |  14 +--
 fs/cifs/smb1ops.c   |   5 +-
 fs/cifs/smb2ops.c   |   2 +-
 6 files changed, 149 insertions(+), 152 deletions(-)

-- 
1.7.11.7
