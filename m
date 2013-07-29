From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] cifs: file: initialize oparms.reconnect before using it
Date: Sun, 28 Jul 2013 22:40:31 -0500
Message-ID: <CAH2r5msP8+qZnb38Rj5WMWmqWFtopmoe671G6TNTB=61BvYEnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Andi Shyti <andi-ahk0KpmfxKRAfugRpC6u6w@public.gmane.org>, mikko.rapeli-X3B1VOXEql0@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Andi,
Your patch looks reasonable.   Would you repost the patch to
linux-cifs mailing list (and add any additional reviewers or testers
if you would like if you got feedback)?



On Mon, Jul 22, 2013 at 09:24:00PM +0200, Andi Shyti wrote:
In the cifs_reopen_file function, if the following statement is
asserted:

(tcon->unix_ext && cap_unix(tcon->ses) &&
(CIFS_UNIX_POSIX_PATH_OPS_CAP &
(tcon->fsUnixInfo.Capability)))

and we succeed to open with cifs_posix_open, the function jumps
to the label reopen_success and checks for oparms.reconnect
which is not initialized.

To avoid this the oparms structure initialization is anticipated
before the if statement.

Signed-off-by: Andi Shyti

fs/cifs/file.c | 18 +++++++++
1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 1e57f36..fbeaf45 100644
a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -632,6 +632,15 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool
can_flush)
else
oplock = 0;

+ oparms.tcon = tcon;
+ oparms.cifs_sb = cifs_sb;
+ oparms.desired_access = desired_access;
+ oparms.create_options = create_options;
+ oparms.disposition = disposition;
+ oparms.path = full_path;
+ oparms.fid = &cfile->fid;
+ oparms.reconnect = true;
+
if (tcon->unix_ext && cap_unix(tcon->ses) &&
(CIFS_UNIX_POSIX_PATH_OPS_CAP &
le64_to_cpu(tcon->fsUnixInfo.Capability))) {
@@ -663,15 +672,6 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool
can_flush)
if (server->ops->get_lease_key)
server->ops->get_lease_key(inode, &cfile->fid);

- oparms.tcon = tcon;
- oparms.cifs_sb = cifs_sb;
- oparms.desired_access = desired_access;
- oparms.create_options = create_options;
- oparms.disposition = disposition;
- oparms.path = full_path;
- oparms.fid = &cfile->fid;
- oparms.reconnect = true;
-
/*
* Can not refresh inode by passing in file_info buf to be returned by
* CIFSSMBOpen and then calling get_inode_info with returned buf sinc

--
Thanks,

Steve
