From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/6] cifs: add separate cred_uid field to sesInfo
Date: Sun, 20 Jun 2010 17:10:51 -0400
Message-ID: <1277068251-16344-7-git-send-email-jlayton@redhat.com>
References: <1277068251-16344-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277068251-16344-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Right now, there's no clear separation between the uid that owns the
credentials used to do the mount and the overriding owner of the files
on that mount.

Add a separate cred_uid field that is set to the real uid
of the mount user. Unlike the linux_uid, the uid= option does not
override this parameter. The parm is sent to cifs.upcall, which can then
preferentially use the creduid= parm instead of the uid= parm for
finding credentials.

This is not the only way to solve this. We could try to do all of this
in kernel instead by having a module parameter that affects what gets
passed in the uid= field of the upcall. That said, we have a lot more
flexibility to change things in userspace so I think it probably makes
sense to do it this way.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_spnego.c |    3 +++
 fs/cifs/cifsglob.h    |    3 ++-
 fs/cifs/connect.c     |    7 +++++--
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 379bd7d..6effccf 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -144,6 +144,9 @@ cifs_get_spnego_key(struct cifsSesInfo *sesInfo)
 	sprintf(dp, ";uid=0x%x", sesInfo->linux_uid);
 
 	dp = description + strlen(description);
+	sprintf(dp, ";creduid=0x%x", sesInfo->cred_uid);
+
+	dp = description + strlen(description);
 	sprintf(dp, ";user=%s", sesInfo->userName);
 
 	dp = description + strlen(description);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 415703b..e15d7a5 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -209,7 +209,8 @@ struct cifsSesInfo {
 	char *serverNOS;	/* name of network operating system of server */
 	char *serverDomain;	/* security realm of server */
 	int Suid;		/* remote smb uid  */
-	uid_t linux_uid;        /* local Linux uid */
+	uid_t linux_uid;        /* overriding owner of files on the mount */
+	uid_t cred_uid;		/* owner of credentials */
 	int capabilities;
 	char serverName[SERVER_NAME_LEN_WITH_NULL * 2];	/* BB make bigger for
 				TCP names - will ipv6 and sctp addresses fit? */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 58e0217..920d94e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -66,6 +66,7 @@ struct smb_vol {
 	char *iocharset;  /* local code page for mapping to and from Unicode */
 	char source_rfc1001_name[16]; /* netbios name of client */
 	char target_rfc1001_name[16]; /* netbios name of server for Win9x/ME */
+	uid_t cred_uid;
 	uid_t linux_uid;
 	gid_t linux_gid;
 	mode_t file_mode;
@@ -830,7 +831,8 @@ cifs_parse_mount_options(char *options, const char *devname,
 	/* null target name indicates to use *SMBSERVR default called name
 	   if we end up sending RFC1001 session initialize */
 	vol->target_rfc1001_name[0] = 0;
-	vol->linux_uid = current_uid();  /* use current_euid() instead? */
+	vol->cred_uid = current_uid();
+	vol->linux_uid = current_uid();
 	vol->linux_gid = current_gid();
 
 	/* default to only allowing write access to owner of the mount */
@@ -1647,7 +1649,7 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 		switch (server->secType) {
 		case Kerberos:
-			if (vol->linux_uid != ses->linux_uid)
+			if (vol->cred_uid != ses->cred_uid)
 				continue;
 			break;
 		default:
@@ -1764,6 +1766,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 		if (ses->domainName)
 			strcpy(ses->domainName, volume_info->domainname);
 	}
+	ses->cred_uid = volume_info->cred_uid;
 	ses->linux_uid = volume_info->linux_uid;
 	ses->overrideSecFlg = volume_info->secFlg;
 
-- 
1.6.6.1
