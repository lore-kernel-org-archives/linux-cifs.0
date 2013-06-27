From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [cifs] smb2 mounts with signing fail due to incorrect
 security mode bits check
Date: Thu, 27 Jun 2013 07:54:59 -0400
Message-ID: <20130627075459.68bd864d@corrin.poochiereds.net>
References: <1372279639-31426-1-git-send-email-shirishpargaonkar@gmail.com>
	<CADT32eJvWa1f6fbfxWmo+_DH-SnMGsP3wH3HHxf9V6Chc73urA@mail.gmail.com>
	<CAH2r5mu0QSjZ5E0tepmKw=SuXuhx1SgVu-BPsX_ZMijzwW5zdA@mail.gmail.com>
	<CADT32eKX9yAS4iKZWQnUEaS95W5i2z2EFsVBe03ff9uRzUsa=g@mail.gmail.com>
	<20130626210944.59bf3827@corrin.poochiereds.net>
	<CAH2r5mv+K7CE8ApnUR2q0kf=cLaLPRDCP+4QNUYZ4mivtbRtMA@mail.gmail.com>
	<20130627004345.279cfb02@tlielax.poochiereds.net>
	<CAH2r5mtiK1is8ZxMbUv60jQKbSZ1tV7MsCBT25QHNJNCdPDi4g@mail.gmail.com>
	<20130627074038.60f4328b@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130627074038.60f4328b-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 27 Jun 2013 07:40:38 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Thu, 27 Jun 2013 02:55:34 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > How about this patch to fix the problem that Shirish noted? It seemed
> > simple to simply map the two SMB2 flags to the older style flags that
> > we check in the sec_mode.
> > 
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index 2b312e4..8f0a46b 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -318,6 +318,23 @@ free_rsp_buf(int resp_buftype, void *rsp)
> >  		cifs_buf_release(rsp);
> >  }
> > 
> > +/* convert smb2 sec mode to older form so can be used for both smb2 and cifs */
> > +static __u16
> > +convert_sec_mode(__u16 smb2_sec_mode)
> > +{
> > +	u16 sec_mode = 0;
> > +
> > +	if ((smb2_sec_mode & SMB2_SEC_MODE_MASK) != smb2_sec_mode)
> > +		cifs_dbg(VFS, "srv ret unknown sec_mode 0x%x\n", smb2_sec_mode);
> > +
> > +	if (smb2_sec_mode & SMB2_NEGOTIATE_SIGNING_ENABLED)
> > +		sec_mode |= SECMODE_SIGN_ENABLED;
> > +
> > +	if (smb2_sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED)
> > +		sec_mode |= SECMODE_SIGN_REQUIRED;
> > +
> > +	return sec_mode;
> > +}
> > 
> >  /*
> >   *
> > @@ -416,8 +433,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
> >  	server->maxBuf = le32_to_cpu(rsp->MaxTransactSize);
> >  	server->max_read = le32_to_cpu(rsp->MaxReadSize);
> >  	server->max_write = le32_to_cpu(rsp->MaxWriteSize);
> > -	/* BB Do we need to validate the SecurityMode? */
> > -	server->sec_mode = le16_to_cpu(rsp->SecurityMode);
> > +	server->sec_mode = convert_sec_mode(le16_to_cpu(rsp->SecurityMode));
> >  	server->capabilities = le32_to_cpu(rsp->Capabilities);
> >  	/* Internal types */
> >  	server->capabilities |= SMB2_NT_FIND | SMB2_LARGE_FILES;
> > diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> > index f31043b..c7534ee 100644
> > --- a/fs/cifs/smb2pdu.h
> > +++ b/fs/cifs/smb2pdu.h
> > @@ -176,6 +176,7 @@ struct smb2_negotiate_req {
> >  /* SecurityMode flags */
> >  #define	SMB2_NEGOTIATE_SIGNING_ENABLED	0x0001
> >  #define SMB2_NEGOTIATE_SIGNING_REQUIRED	0x0002
> > +#define SMB2_SEC_MODE_MASK		0x0003
> >  /* Capabilities flags */
> >  #define SMB2_GLOBAL_CAP_DFS		0x00000001
> >  #define SMB2_GLOBAL_CAP_LEASING		0x00000002 /* Resp only New to SMB2.1 */
> > 
> 
> I think it would be best to try and preserve the sec_mode field as-is...
> 
> Maybe something like this (untested) patch instead?
> 

v2...

The ENABLED and REQUIRED bits are exclusive in SMB2 field, so we have
to check for both when setting the srv_sign_enabled flag.

--------------------[snip]-----------------------

cifs: fix SMB2 signing enablement in cifs_enable_signing

Commit 9ddec56131 (cifs: move handling of signed connections into
separate function) broke signing on SMB2/3 connections. While the code
to enable signing on the connections was very similar between the two,
the bits that get set in the sec_mode are different.

Declare a couple of new smb_version_values fields and set them
appropriately for SMB1 and SMB2/3. Then change cifs_enable_signing to
use those instead.

Reported-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h | 2 ++
 fs/cifs/cifssmb.c  | 4 ++--
 fs/cifs/smb1ops.c  | 2 ++
 fs/cifs/smb2ops.c  | 8 ++++++++
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b0f077e..e66b088 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -387,6 +387,8 @@ struct smb_version_values {
 	unsigned int	cap_nt_find;
 	unsigned int	cap_large_files;
 	unsigned int	oplock_read;
+	__u16		signing_enabled;
+	__u16		signing_required;
 };
 
 #define HEADER_SIZE(server) (server->vals->header_size)
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a35aad2..bc7dfa8 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -407,8 +407,8 @@ decode_ext_sec_blob(struct cifs_ses *ses, NEGOTIATE_RSP *pSMBr)
 int
 cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required)
 {
-	bool srv_sign_required = server->sec_mode & SECMODE_SIGN_REQUIRED;
-	bool srv_sign_enabled = server->sec_mode & SECMODE_SIGN_ENABLED;
+	bool srv_sign_required = server->sec_mode & server->vals->signing_required;
+	bool srv_sign_enabled = server->sec_mode & server->vals->signing_enabled;
 	bool mnt_sign_enabled = global_secflags & CIFSSEC_MAY_SIGN;
 
 	/*
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index b28aabd..e813f04 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -957,4 +957,6 @@ struct smb_version_values smb1_values = {
 	.cap_nt_find = CAP_NT_SMBS | CAP_NT_FIND,
 	.cap_large_files = CAP_LARGE_FILES,
 	.oplock_read = OPLOCK_READ,
+	.signing_enabled = SECMODE_SIGN_ENABLED,
+	.signing_required = SECMODE_SIGN_REQUIRED,
 };
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 48fe7c4..6d15cab 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -729,6 +729,8 @@ struct smb_version_values smb20_values = {
 	.cap_nt_find = SMB2_NT_FIND,
 	.cap_large_files = SMB2_LARGE_FILES,
 	.oplock_read = SMB2_OPLOCK_LEVEL_II,
+	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
+	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 };
 
 struct smb_version_values smb21_values = {
@@ -747,6 +749,8 @@ struct smb_version_values smb21_values = {
 	.cap_nt_find = SMB2_NT_FIND,
 	.cap_large_files = SMB2_LARGE_FILES,
 	.oplock_read = SMB2_OPLOCK_LEVEL_II,
+	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
+	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 };
 
 struct smb_version_values smb30_values = {
@@ -765,6 +769,8 @@ struct smb_version_values smb30_values = {
 	.cap_nt_find = SMB2_NT_FIND,
 	.cap_large_files = SMB2_LARGE_FILES,
 	.oplock_read = SMB2_OPLOCK_LEVEL_II,
+	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
+	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 };
 
 struct smb_version_values smb302_values = {
@@ -783,4 +789,6 @@ struct smb_version_values smb302_values = {
 	.cap_nt_find = SMB2_NT_FIND,
 	.cap_large_files = SMB2_LARGE_FILES,
 	.oplock_read = SMB2_OPLOCK_LEVEL_II,
+	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
+	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 };
-- 
1.8.1.4
