From: Jeff Layton <jlayton@samba.org>
Subject: Re: [linux-cifs-client] [PATCH] cifs: hard mount option behaviour
 implementation
Date: Sun, 6 Jun 2010 06:51:24 -0400
Message-ID: <20100606065124.065db32a@tlielax.poochiereds.net>
References: <1275755825-6504-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org
To: shirishpargaonkar@gmail.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1275755825-6504-1-git-send-email-shirishpargaonkar@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sat,  5 Jun 2010 11:37:05 -0500
shirishpargaonkar@gmail.com wrote:

> Add support for hard mount option by using -o hard.
> 
> Current cifs behaviour amounts to that of a soft mount.
> If a response for a command does not arrive within a certain timeout,
> server is considered non-responsive and a reconnect is attempted.
> Commands/requests are returned with error for an app to decide.
> 
> This code change adds hard mount option behaviour.
> A command waits in interruptible wait timing out every 60 seconds
> to log a debug message about server not responding and going
> back on interruptible wait queue for another 60 seconds.
> Once response arrives, a debug messages is logged that server is
> responding.
> An user has an option to interrupt a program if a response has not
> arrived for long enough for user to deem a dead server and retry
> the program.
> This takes care of unnecessary reconnects and subsequent retries
> of numerous commands for invalidated file handles etc. when either
> the server or client is stressed or slow. 
> 
> These commands such as negotiate, session setup, tree connect, 
> logoff, non-blocking posix lock, and dfs referral are always soft.
> 
> 

Looks like a step in the right direction. I think this will help bring
better data integrity to CIFS. We really need to strive to minimize
reconnects since they are so costly and you lose things like file
locks, etc...

Comments inline below:

> From b1b0a7b1612dc3d865b4756dfddceeab4245a888 Mon Sep 17 00:00:00 2001
> From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
> Date: Sat, 5 Jun 2010 10:01:06 -0500
> Subject: [PATCH] add support for implementing hard mount option behaviour
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
> ---
>  fs/cifs/cifsproto.h |    7 ++-
>  fs/cifs/cifssmb.c   |  126 +++++++++++++++++++++++++++-----------------------
>  fs/cifs/connect.c   |    5 ++-
>  fs/cifs/sess.c      |    2 +-
>  fs/cifs/transport.c |   62 ++++++++++++++++++++++---
>  5 files changed, 132 insertions(+), 70 deletions(-)
> 
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index fb1657e..7a475c5 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -63,12 +63,13 @@ extern char *cifs_compose_mount_options(const char *sb_mountdata,
>  extern int SendReceive(const unsigned int /* xid */ , struct cifsSesInfo *,
>  			struct smb_hdr * /* input */ ,
>  			struct smb_hdr * /* out */ ,
> -			int * /* bytes returned */ , const int long_op);
> +			int * /* bytes returned */ , const int long_op, bool);
>  extern int SendReceiveNoRsp(const unsigned int xid, struct cifsSesInfo *ses,
> -			struct smb_hdr *in_buf, int flags);
> +			struct smb_hdr *in_buf, int flags, bool hard_mount);
>  extern int SendReceive2(const unsigned int /* xid */ , struct cifsSesInfo *,
>  			struct kvec *, int /* nvec to send */,
> -			int * /* type of buf returned */ , const int flags);
> +			int * /* type of buf returned */ , const int flags,
> +			bool);
>  extern int SendReceiveBlockingLock(const unsigned int xid,
>  			struct cifsTconInfo *ptcon,
>  			struct smb_hdr *in_buf ,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index c65c341..2634354 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -404,7 +404,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>  	pSMB->ByteCount = cpu_to_le16(count);
>  
>  	rc = SendReceive(xid, ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, false);
>  	if (rc != 0)
>  		goto neg_err_exit;
>  
> @@ -678,7 +678,7 @@ CIFSSMBTDis(const int xid, struct cifsTconInfo *tcon)
>  	if (rc)
>  		return rc;
>  
> -	rc = SendReceiveNoRsp(xid, tcon->ses, smb_buffer, 0);
> +	rc = SendReceiveNoRsp(xid, tcon->ses, smb_buffer, 0, tcon->retry);


I know that this parameter predates your patch, but I'm not sure that
the "retry" option ought to hang off of the tcon. I think it should
hang off of the superblock instead. It ought to be possible for someone
to mount the same share with both hard and soft options simultaneously.

In fact, the default timeout for soft mounts ought to be tunable as well.
What may be best is to add a "call timeout" field to the superblock and
set that to '0' for hard mounts and then drop the "retry" parm on the
tcon.

>  	if (rc)
>  		cFYI(1, "Tree disconnect failed %d", rc);
>  
> @@ -725,7 +725,7 @@ CIFSSMBLogoff(const int xid, struct cifsSesInfo *ses)
>  	pSMB->hdr.Uid = ses->Suid;
>  
>  	pSMB->AndXCommand = 0xFF;
> -	rc = SendReceiveNoRsp(xid, ses, (struct smb_hdr *) pSMB, 0);
> +	rc = SendReceiveNoRsp(xid, ses, (struct smb_hdr *) pSMB, 0, false);
>  session_already_dead:
>  	mutex_unlock(&ses->session_mutex);
>  
> @@ -799,7 +799,7 @@ PsxDelete:
>  	pSMB->hdr.smb_buf_length += byte_count;
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		(struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc)
>  		cFYI(1, "Posix delete returned %d", rc);
>  	cifs_buf_release(pSMB);
> @@ -845,7 +845,7 @@ DelFileRetry:
>  	pSMB->hdr.smb_buf_length += name_len + 1;
>  	pSMB->ByteCount = cpu_to_le16(name_len + 1);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		(struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	cifs_stats_inc(&tcon->num_deletes);
>  	if (rc)
>  		cFYI(1, "Error in RMFile = %d", rc);
> @@ -889,7 +889,7 @@ RmDirRetry:
>  	pSMB->hdr.smb_buf_length += name_len + 1;
>  	pSMB->ByteCount = cpu_to_le16(name_len + 1);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		(struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	cifs_stats_inc(&tcon->num_rmdirs);
>  	if (rc)
>  		cFYI(1, "Error in RMDir = %d", rc);
> @@ -932,7 +932,7 @@ MkDirRetry:
>  	pSMB->hdr.smb_buf_length += name_len + 1;
>  	pSMB->ByteCount = cpu_to_le16(name_len + 1);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	cifs_stats_inc(&tcon->num_mkdirs);
>  	if (rc)
>  		cFYI(1, "Error in Mkdir = %d", rc);
> @@ -1010,7 +1010,7 @@ PsxCreat:
>  	pSMB->hdr.smb_buf_length += byte_count;
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Posix create returned %d", rc);
>  		goto psx_create_err;
> @@ -1177,7 +1177,8 @@ OldOpenRetry:
>  	pSMB->ByteCount = cpu_to_le16(count);
>  	/* long_op set to 1 to allow for oplock break timeouts */
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			(struct smb_hdr *)pSMBr, &bytes_returned, CIFS_LONG_OP);
> +		(struct smb_hdr *)pSMBr, &bytes_returned, CIFS_LONG_OP,
> +		tcon->retry);
>  	cifs_stats_inc(&tcon->num_opens);
>  	if (rc) {
>  		cFYI(1, "Error in Open = %d", rc);
> @@ -1290,7 +1291,8 @@ openRetry:
>  	pSMB->ByteCount = cpu_to_le16(count);
>  	/* long_op set to 1 to allow for oplock break timeouts */
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			(struct smb_hdr *)pSMBr, &bytes_returned, CIFS_LONG_OP);
> +		(struct smb_hdr *)pSMBr, &bytes_returned, CIFS_LONG_OP,
> +		tcon->retry);
>  	cifs_stats_inc(&tcon->num_opens);
>  	if (rc) {
>  		cFYI(1, "Error in Open = %d", rc);
> @@ -1372,7 +1374,7 @@ CIFSSMBRead(const int xid, struct cifsTconInfo *tcon, const int netfid,
>  	iov[0].iov_base = (char *)pSMB;
>  	iov[0].iov_len = pSMB->hdr.smb_buf_length + 4;
>  	rc = SendReceive2(xid, tcon->ses, iov, 1 /* num iovecs */,
> -			 &resp_buf_type, CIFS_STD_OP | CIFS_LOG_ERROR);
> +		 &resp_buf_type, CIFS_STD_OP | CIFS_LOG_ERROR, tcon->retry);
>  	cifs_stats_inc(&tcon->num_reads);
>  	pSMBr = (READ_RSP *)iov[0].iov_base;
>  	if (rc) {
> @@ -1516,7 +1518,8 @@ CIFSSMBWrite(const int xid, struct cifsTconInfo *tcon,
>  	}
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, long_op);
> +		(struct smb_hdr *) pSMBr, &bytes_returned, long_op,
> +		tcon->retry);
>  	cifs_stats_inc(&tcon->num_writes);
>  	if (rc) {
>  		cFYI(1, "Send error in write = %d", rc);
> @@ -1608,7 +1611,7 @@ CIFSSMBWrite2(const int xid, struct cifsTconInfo *tcon,
>  
>  
>  	rc = SendReceive2(xid, tcon->ses, iov, n_vec + 1, &resp_buf_type,
> -			  long_op);
> +			  long_op, tcon->retry);
>  	cifs_stats_inc(&tcon->num_writes);
>  	if (rc) {
>  		cFYI(1, "Send error Write2 = %d", rc);
> @@ -1699,7 +1702,7 @@ CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
>  		cifs_small_buf_release(pSMB);
>  	} else {
>  		rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *)pSMB,
> -				      timeout);
> +				      timeout, tcon->retry);
>  		/* SMB buffer freed by function above */
>  	}
>  	cifs_stats_inc(&tcon->num_locks);
> @@ -1790,7 +1793,7 @@ CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
>  		iov[0].iov_base = (char *)pSMB;
>  		iov[0].iov_len = pSMB->hdr.smb_buf_length + 4;
>  		rc = SendReceive2(xid, tcon->ses, iov, 1 /* num iovecs */,
> -				&resp_buf_type, timeout);
> +				&resp_buf_type, timeout, false);
>  		pSMB = NULL; /* request buf already freed by SendReceive2. Do
>  				not try to free it twice below on exit */
>  		pSMBr = (struct smb_com_transaction2_sfi_rsp *)iov[0].iov_base;
> @@ -1866,7 +1869,8 @@ CIFSSMBClose(const int xid, struct cifsTconInfo *tcon, int smb_file_id)
>  	pSMB->FileID = (__u16) smb_file_id;
>  	pSMB->LastWriteTime = 0xFFFFFFFF;
>  	pSMB->ByteCount = 0;
> -	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
> +	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0,
> +				tcon->retry);
>  	cifs_stats_inc(&tcon->num_closes);
>  	if (rc) {
>  		if (rc != -EINTR) {
> @@ -1895,7 +1899,8 @@ CIFSSMBFlush(const int xid, struct cifsTconInfo *tcon, int smb_file_id)
>  
>  	pSMB->FileID = (__u16) smb_file_id;
>  	pSMB->ByteCount = 0;
> -	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
> +	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0,
> +				tcon->retry);
>  	cifs_stats_inc(&tcon->num_flushes);
>  	if (rc)
>  		cERROR(1, "Send error in Flush = %d", rc);
> @@ -1958,7 +1963,7 @@ renameRetry:
>  	pSMB->ByteCount = cpu_to_le16(count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	cifs_stats_inc(&tcon->num_renames);
>  	if (rc)
>  		cFYI(1, "Send error in rename = %d", rc);
> @@ -2037,7 +2042,7 @@ int CIFSSMBRenameOpenFile(const int xid, struct cifsTconInfo *pTcon,
>  	pSMB->hdr.smb_buf_length += byte_count;
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  	rc = SendReceive(xid, pTcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, pTcon->retry);
>  	cifs_stats_inc(&pTcon->num_t2renames);
>  	if (rc)
>  		cFYI(1, "Send error in Rename (by file handle) = %d", rc);
> @@ -2105,7 +2110,7 @@ copyRetry:
>  	pSMB->ByteCount = cpu_to_le16(count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		(struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Send error in copy = %d with %d files copied",
>  			rc, le16_to_cpu(pSMBr->CopyCount));
> @@ -2194,7 +2199,7 @@ createSymLinkRetry:
>  	pSMB->hdr.smb_buf_length += byte_count;
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	cifs_stats_inc(&tcon->num_symlinks);
>  	if (rc)
>  		cFYI(1, "Send error in SetPathInfo create symlink = %d", rc);
> @@ -2280,7 +2285,7 @@ createHardLinkRetry:
>  	pSMB->hdr.smb_buf_length += byte_count;
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	cifs_stats_inc(&tcon->num_hardlinks);
>  	if (rc)
>  		cFYI(1, "Send error in SetPathInfo (hard link) = %d", rc);
> @@ -2352,7 +2357,7 @@ winCreateHardLinkRetry:
>  	pSMB->ByteCount = cpu_to_le16(count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	cifs_stats_inc(&tcon->num_hardlinks);
>  	if (rc)
>  		cFYI(1, "Send error in hard link (NT rename) = %d", rc);
> @@ -2423,7 +2428,7 @@ querySymLinkRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Send error in QuerySymLinkInfo = %d", rc);
>  	} else {
> @@ -2586,7 +2591,7 @@ CIFSSMBQueryReparseLinkInfo(const int xid, struct cifsTconInfo *tcon,
>  	pSMB->ByteCount = 0;
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Send error in QueryReparseLinkInfo = %d", rc);
>  	} else {		/* decode response */
> @@ -2849,7 +2854,7 @@ queryAclRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		(struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	cifs_stats_inc(&tcon->num_acl_get);
>  	if (rc) {
>  		cFYI(1, "Send error in Query POSIX ACL = %d", rc);
> @@ -2942,7 +2947,7 @@ setAclRetry:
>  	pSMB->hdr.smb_buf_length += byte_count;
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc)
>  		cFYI(1, "Set POSIX ACL returned %d", rc);
>  
> @@ -3001,7 +3006,7 @@ GetExtAttrRetry:
>  	pSMB->t2.ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "error %d in GetExtAttr", rc);
>  	} else {
> @@ -3070,7 +3075,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
>  	iov[0].iov_len = pSMB->hdr.smb_buf_length + 4;
>  
>  	rc = SendReceive2(xid, tcon->ses, iov, 1 /* num iovec */, &buf_type,
> -			 CIFS_STD_OP);
> +			 CIFS_STD_OP, tcon->retry);
>  	cifs_stats_inc(&tcon->num_acl_get);
>  	if (rc) {
>  		cFYI(1, "Send error in QuerySecDesc = %d", rc);
> @@ -3182,7 +3187,7 @@ setCifsAclRetry:
>  		pSMB->hdr.smb_buf_length += byte_count;
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		(struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  
>  	cFYI(1, "SetCIFSACL bytes_returned: %d, rc: %d", bytes_returned, rc);
>  	if (rc)
> @@ -3234,7 +3239,7 @@ QInfRetry:
>  	pSMB->ByteCount = cpu_to_le16(name_len);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Send error in QueryInfo = %d", rc);
>  	} else if (pFinfo) {
> @@ -3308,7 +3313,7 @@ QFileInfoRetry:
>  	pSMB->hdr.smb_buf_length += byte_count;
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Send error in QPathInfo = %d", rc);
>  	} else {		/* decode response */
> @@ -3396,7 +3401,7 @@ QPathInfoRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Send error in QPathInfo = %d", rc);
>  	} else {		/* decode response */
> @@ -3476,7 +3481,7 @@ UnixQFileInfoRetry:
>  	pSMB->hdr.smb_buf_length += byte_count;
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Send error in QPathInfo = %d", rc);
>  	} else {		/* decode response */
> @@ -3562,7 +3567,7 @@ UnixQPathInfoRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Send error in QPathInfo = %d", rc);
>  	} else {		/* decode response */
> @@ -3676,7 +3681,7 @@ findFirstRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	cifs_stats_inc(&tcon->num_ffirst);
>  
>  	if (rc) {/* BB add logic to retry regular search if Unix search
> @@ -3805,7 +3810,7 @@ int CIFSFindNext(const int xid, struct cifsTconInfo *tcon,
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			(struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		(struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	cifs_stats_inc(&tcon->num_fnext);
>  	if (rc) {
>  		if (rc == -EBADF) {
> @@ -3894,7 +3899,8 @@ CIFSFindClose(const int xid, struct cifsTconInfo *tcon,
>  
>  	pSMB->FileID = searchHandle;
>  	pSMB->ByteCount = 0;
> -	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
> +	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0,
> +				tcon->retry);
>  	if (rc)
>  		cERROR(1, "Send error in FindClose = %d", rc);
>  
> @@ -3967,7 +3973,7 @@ GetInodeNumberRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		(struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "error %d in QueryInternalInfo", rc);
>  	} else {
> @@ -4191,7 +4197,7 @@ getDFSRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, false);
>  	if (rc) {
>  		cFYI(1, "Send error in GetDFSRefer = %d", rc);
>  		goto GetDFSRefExit;
> @@ -4265,7 +4271,7 @@ oldQFSInfoRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		(struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Send error in QFSInfo = %d", rc);
>  	} else {                /* decode response */
> @@ -4344,7 +4350,7 @@ QFSInfoRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Send error in QFSInfo = %d", rc);
>  	} else {		/* decode response */
> @@ -4424,7 +4430,7 @@ QFSAttributeRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cERROR(1, "Send error in QFSAttributeInfo = %d", rc);
>  	} else {		/* decode response */
> @@ -4495,7 +4501,7 @@ QFSDeviceRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Send error in QFSDeviceInfo = %d", rc);
>  	} else {		/* decode response */
> @@ -4564,7 +4570,7 @@ QFSUnixRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cERROR(1, "Send error in QFSUnixInfo = %d", rc);
>  	} else {		/* decode response */
> @@ -4647,7 +4653,7 @@ SETFSUnixRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cERROR(1, "Send error in SETFSUnixInfo = %d", rc);
>  	} else {		/* decode response */
> @@ -4709,7 +4715,7 @@ QFSPosixRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Send error in QFSUnixInfo = %d", rc);
>  	} else {		/* decode response */
> @@ -4835,7 +4841,7 @@ SetEOFRetry:
>  	parm_data->FileSize = cpu_to_le64(size);
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc)
>  		cFYI(1, "SetPathInfo (file size) returned %d", rc);
>  
> @@ -4915,7 +4921,8 @@ CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon, __u64 size,
>  	pSMB->Reserved4 = 0;
>  	pSMB->hdr.smb_buf_length += byte_count;
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
> -	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
> +	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0,
> +				tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Send error in SetFileInfo (SetFileSize) = %d", rc);
>  	}
> @@ -4984,7 +4991,8 @@ CIFSSMBSetFileInfo(const int xid, struct cifsTconInfo *tcon,
>  	pSMB->hdr.smb_buf_length += byte_count;
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  	memcpy(data_offset, data, sizeof(FILE_BASIC_INFO));
> -	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
> +	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0,
> +				tcon->retry);
>  	if (rc)
>  		cFYI(1, "Send error in Set Time (SetFileInfo) = %d", rc);
>  
> @@ -5043,7 +5051,8 @@ CIFSSMBSetFileDisposition(const int xid, struct cifsTconInfo *tcon,
>  	pSMB->hdr.smb_buf_length += byte_count;
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  	*data_offset = delete_file ? 1 : 0;
> -	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
> +	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0,
> +				tcon->retry);
>  	if (rc)
>  		cFYI(1, "Send error in SetFileDisposition = %d", rc);
>  
> @@ -5117,7 +5126,7 @@ SetTimesRetry:
>  	memcpy(data_offset, data, sizeof(FILE_BASIC_INFO));
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc)
>  		cFYI(1, "SetPathInfo (times) returned %d", rc);
>  
> @@ -5275,7 +5284,8 @@ CIFSSMBUnixSetFileInfo(const int xid, struct cifsTconInfo *tcon,
>  
>  	cifs_fill_unix_set_info(data_offset, args);
>  
> -	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
> +	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0,
> +				tcon->retry);
>  	if (rc)
>  		cFYI(1, "Send error in Set Time (SetFileInfo) = %d", rc);
>  
> @@ -5352,7 +5362,7 @@ setPermsRetry:
>  
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc)
>  		cFYI(1, "SetPathInfo (perms) returned %d", rc);
>  
> @@ -5404,8 +5414,8 @@ int CIFSSMBNotify(const int xid, struct cifsTconInfo *tcon,
>  	pSMB->ByteCount = 0;
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *)pSMBr, &bytes_returned,
> -			 CIFS_ASYNC_OP);
> +		(struct smb_hdr *)pSMBr, &bytes_returned, CIFS_ASYNC_OP,
> +		tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Error in Notify = %d", rc);
>  	} else {
> @@ -5508,7 +5518,7 @@ QAllEAsRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc) {
>  		cFYI(1, "Send error in QueryAllEAs = %d", rc);
>  		goto QAllEAsOut;
> @@ -5720,7 +5730,7 @@ SetEARetry:
>  	pSMB->hdr.smb_buf_length += byte_count;
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> +		 (struct smb_hdr *) pSMBr, &bytes_returned, 0, tcon->retry);
>  	if (rc)
>  		cFYI(1, "SetPathInfo (EA) returned %d", rc);
>  
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 2208f06..7ddc602 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1809,6 +1809,9 @@ cifs_get_tcon(struct cifsSesInfo *ses, struct smb_vol *volume_info)
>  		}
>  	}
>  
> +	if (volume_info->retry)
> +		tcon->retry = volume_info->retry;
> +
>  	if (strchr(volume_info->UNC + 3, '\\') == NULL
>  	    && strchr(volume_info->UNC + 3, '/') == NULL) {
>  		cERROR(1, "Missing share name");
> @@ -2807,7 +2810,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
>  	pSMB->ByteCount = cpu_to_le16(count);
>  
>  	rc = SendReceive(xid, ses, smb_buffer, smb_buffer_response, &length,
> -			 CIFS_STD_OP);
> +			 CIFS_STD_OP, false);
>  
>  	/* above now done in SendReceive */
>  	if ((rc == 0) && (tcon != NULL)) {
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 7707389..ff0dfb7 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -866,7 +866,7 @@ ssetup_ntlmssp_authenticate:
>  	BCC_LE(smb_buf) = cpu_to_le16(count);
>  
>  	rc = SendReceive2(xid, ses, iov, 3 /* num_iovecs */, &resp_buf_type,
> -			  CIFS_STD_OP /* not long */ | CIFS_LOG_ERROR);
> +		  CIFS_STD_OP /* not long */ | CIFS_LOG_ERROR, false);
>  	/* SMB request buf freed in SendReceive2 */
>  
>  	cFYI(1, "ssetup rc from sendrecv2 is %d", rc);
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 82f78c4..0c7a07e 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -311,6 +311,44 @@ static int allocate_mid(struct cifsSesInfo *ses, struct smb_hdr *in_buf,
>  	return 0;
>  }
>  
> +static int
> +wait_for_response_hard(struct cifsSesInfo *ses, struct mid_q_entry *midQ)
> +{
> +	int rc;
> +	bool cmdresp = true;
> +	unsigned long timeout = 60 * HZ;
> +	unsigned long curr_timeout;
> +
> +wait_again:
> +	curr_timeout = timeout + jiffies;
> +	rc = wait_event_interruptible_timeout(ses->server->response_q,
> +			(midQ->midState != MID_REQUEST_SUBMITTED), timeout);
> +
> +	if (rc < 0) {
> +		cFYI(1, "command 0x%x interrupted", midQ->command);
> +		return -1;
> +	}
> +	if (!time_before(jiffies, curr_timeout)) {
> +		cmdresp = false;
> +		cFYI(1, "server not responding...");
> +		goto wait_again;
> +	}
> +	spin_lock(&GlobalMid_Lock);
> +	if (midQ->midState != MID_REQUEST_SUBMITTED) {
> +		if (midQ->midState == MID_RESPONSE_RECEIVED) {
> +			if (!cmdresp)
> +				cFYI(1, "server is ok...");
> +			rc = 0;
> +		} else {
> +			cFYI(1, "command 0x%x aborted", midQ->command);
> +			rc = -1;
> +		}
> +	}
> +	spin_unlock(&GlobalMid_Lock);
> +	return rc;
> +}
> +

The cFYI's above could be a bit more descriptive. Which server isn't
responding here? That could be important information. Also maybe this
should be a cERROR printk so that administrators have some sort of clue
as to why the mount seems to be hung. Making those look similar to the
RPC timeout messages with NFS would also add some "consistency" to the
kernel's appearance too.

> +
>  static int wait_for_response(struct cifsSesInfo *ses,
>  			struct mid_q_entry *midQ,
>  			unsigned long timeout,
> @@ -367,7 +405,7 @@ static int wait_for_response(struct cifsSesInfo *ses,
>   */
>  int
>  SendReceiveNoRsp(const unsigned int xid, struct cifsSesInfo *ses,
> -		struct smb_hdr *in_buf, int flags)
> +		struct smb_hdr *in_buf, int flags, bool hard_mount)
>  {
>  	int rc;
>  	struct kvec iov[1];
> @@ -376,7 +414,7 @@ SendReceiveNoRsp(const unsigned int xid, struct cifsSesInfo *ses,
>  	iov[0].iov_base = (char *)in_buf;
>  	iov[0].iov_len = in_buf->smb_buf_length + 4;
>  	flags |= CIFS_NO_RESP;
> -	rc = SendReceive2(xid, ses, iov, 1, &resp_buf_type, flags);
> +	rc = SendReceive2(xid, ses, iov, 1, &resp_buf_type, flags, hard_mount);
>  	cFYI(DBG2, "SendRcvNoRsp flags %d rc %d", flags, rc);
>  
>  	return rc;
> @@ -385,7 +423,7 @@ SendReceiveNoRsp(const unsigned int xid, struct cifsSesInfo *ses,
>  int
>  SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
>  	     struct kvec *iov, int n_vec, int *pRespBufType /* ret */,
> -	     const int flags)
> +	     const int flags, bool hard_mount)
>  {
>  	int rc = 0;
>  	int long_op;
> @@ -483,7 +521,12 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
>  	}
>  
>  	/* No user interrupts in wait - wreaks havoc with performance */
> -	wait_for_response(ses, midQ, timeout, 10 * HZ);
> +	if (hard_mount) {
> +		rc = wait_for_response_hard(ses, midQ);
> +		if (rc)
> +			goto out;
> +	} else
> +		wait_for_response(ses, midQ, timeout, 10 * HZ);

Maybe instead of the above, it may be better to embed whether this is a
hard or soft timeout in the mid queue entry itself. That is, add
another parameter? What may be best is to just put in a timeout
parameter in the mid queue entry and then set that to 0 for hard mounts.

>  
>  	spin_lock(&GlobalMid_Lock);
>  
> @@ -581,7 +624,7 @@ out:
>  int
>  SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
>  	    struct smb_hdr *in_buf, struct smb_hdr *out_buf,
> -	    int *pbytes_returned, const int long_op)
> +	    int *pbytes_returned, const int long_op, bool hard_mount)
>  {
>  	int rc = 0;
>  	unsigned int receive_len;
> @@ -675,7 +718,12 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
>  	}
>  
>  	/* No user interrupts in wait - wreaks havoc with performance */
> -	wait_for_response(ses, midQ, timeout, 10 * HZ);
> +	if (hard_mount) {
> +		rc = wait_for_response_hard(ses, midQ);
> +		if (rc)
> +			goto out;
> +	} else
> +		wait_for_response(ses, midQ, timeout, 10 * HZ);
>  
>  	spin_lock(&GlobalMid_Lock);
>  	if (midQ->resp_buf == NULL) {
> @@ -807,7 +855,7 @@ send_lock_cancel(const unsigned int xid, struct cifsTconInfo *tcon,
>  	pSMB->hdr.Mid = GetNextMid(ses->server);
>  
>  	return SendReceive(xid, ses, in_buf, out_buf,
> -			&bytes_returned, CIFS_STD_OP);
> +			&bytes_returned, CIFS_STD_OP, tcon->retry);
>  }
>  
>  int



-- 
Jeff Layton <jlayton@samba.org>
