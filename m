From: Jeff Layton <jlayton@samba.org>
Subject: Re: [PATCH v2 02/53] CIFS: Allow SMB2 statistics to be tracked
Date: Sat, 29 Oct 2011 00:48:14 -0400
Message-ID: <20111029004814.41340503@corrin.poochiereds.net>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
	<1319831704-3572-3-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Steve French <sfrench@us.ibm.com>
To: Pavel Shilovsky <piastry@etersoft.ru>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1319831704-3572-3-git-send-email-piastry@etersoft.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 28 Oct 2011 23:54:13 +0400
Pavel Shilovsky <piastry@etersoft.ru> wrote:

> From: Steve French <sfrench@us.ibm.com>
> 
> Adding SMB2 statistics requires changes to the way cifs handles stats.
> Since there are only 19 command codes, it also is easier to track by exact
> command code than it was for cifs.  Turn the counters for protocol
> ops sent to be a union (one struct for cifs, one for smb2).  While at it
> split out the functions which clear stats and prints stats into their own
> subfunctions so they are easy to read and don't go past 80 columns.
> 
> Signed-off-by: Steve French <sfrench@us.ibm.com>
> Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
> ---
>  fs/cifs/cifs_debug.c |  146 ++++++++++++++++++++++++++++++-------------------
>  fs/cifs/cifsglob.h   |   56 ++++++++++++-------
>  fs/cifs/cifssmb.c    |   54 +++++++++---------
>  fs/cifs/misc.c       |    2 +-
>  4 files changed, 152 insertions(+), 106 deletions(-)
> 
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 84e8c07..8ccdb15 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -249,6 +249,55 @@ static const struct file_operations cifs_debug_data_proc_fops = {
>  };
>  
>  #ifdef CONFIG_CIFS_STATS
> +
> +#ifdef CONFIG_CIFS_SMB2
> +static void smb2_clear_stats(struct cifs_tcon *tcon)
> +{
> +	int i;
> +
> +	atomic_set(&tcon->num_smbs_sent, 0);
> +	for (i = 0; i < NUMBER_OF_SMB2_COMMANDS; i++) {
> +		atomic_set(&tcon->stats.smb2_stats.smb2_com_sent[i], 0);
> +		atomic_set(&tcon->stats.smb2_stats.smb2_com_fail[i], 0);
> +	}
> +}
> +#endif /* CONFIG_CIFS_SMB2 */
> +
> +static void clear_cifs_stats(struct cifs_tcon *tcon)
> +{
> +	atomic_set(&tcon->num_smbs_sent, 0);
> +
> +#ifdef CONFIG_CIFS_SMB2
> +	if (tcon->ses->server->is_smb2) {
> +		smb2_clear_stats(tcon);
> +		return;
> +	}
> +#endif /* CONFIG_CIFS_SMB2 */
> +

     ^^^^^^^^^^^^^
The above logic should be encapsulated in smb2_clear_stats, and that
function should just be a noop when CONFIG_CIFS_SMB2 is not set.

> +	/* cifs specific statistics, not applicable to smb2 sessions */
> +	atomic_set(&tcon->stats.cifs_stats.num_writes, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_reads, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_flushes, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_oplock_brks, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_opens, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_posixopens, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_posixmkdirs, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_closes, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_deletes, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_mkdirs, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_rmdirs, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_renames, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_t2renames, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_ffirst, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_fnext, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_fclose, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_hardlinks, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_symlinks, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_locks, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_acl_get, 0);
> +	atomic_set(&tcon->stats.cifs_stats.num_acl_set, 0);
> +}
> +
>  static ssize_t cifs_stats_proc_write(struct file *file,
>  		const char __user *buffer, size_t count, loff_t *ppos)
>  {
> @@ -279,25 +328,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
>  					tcon = list_entry(tmp3,
>  							  struct cifs_tcon,
>  							  tcon_list);
> -					atomic_set(&tcon->num_smbs_sent, 0);
> -					atomic_set(&tcon->num_writes, 0);
> -					atomic_set(&tcon->num_reads, 0);
> -					atomic_set(&tcon->num_oplock_brks, 0);
> -					atomic_set(&tcon->num_opens, 0);
> -					atomic_set(&tcon->num_posixopens, 0);
> -					atomic_set(&tcon->num_posixmkdirs, 0);
> -					atomic_set(&tcon->num_closes, 0);
> -					atomic_set(&tcon->num_deletes, 0);
> -					atomic_set(&tcon->num_mkdirs, 0);
> -					atomic_set(&tcon->num_rmdirs, 0);
> -					atomic_set(&tcon->num_renames, 0);
> -					atomic_set(&tcon->num_t2renames, 0);
> -					atomic_set(&tcon->num_ffirst, 0);
> -					atomic_set(&tcon->num_fnext, 0);
> -					atomic_set(&tcon->num_fclose, 0);
> -					atomic_set(&tcon->num_hardlinks, 0);
> -					atomic_set(&tcon->num_symlinks, 0);
> -					atomic_set(&tcon->num_locks, 0);
> +					clear_cifs_stats(tcon);
>  				}
>  			}
>  		}
> @@ -307,6 +338,44 @@ static ssize_t cifs_stats_proc_write(struct file *file,
>  	return count;
>  }
>  
> +static void cifs_stats_print(struct seq_file *m, struct cifs_tcon *tcon)
> +{
> +	if (tcon->need_reconnect)
> +		seq_puts(m, "\tDISCONNECTED ");
> +	seq_printf(m, "\nSMBs: %d Oplock Breaks: %d",
> +		atomic_read(&tcon->num_smbs_sent),
> +		atomic_read(&tcon->stats.cifs_stats.num_oplock_brks));
> +	seq_printf(m, "\nReads:  %d Bytes: %lld",
> +		atomic_read(&tcon->stats.cifs_stats.num_reads),
> +		(long long)(tcon->bytes_read));
> +	seq_printf(m, "\nWrites: %d Bytes: %lld",
> +		atomic_read(&tcon->stats.cifs_stats.num_writes),
> +		(long long)(tcon->bytes_written));
> +	seq_printf(m, "\nFlushes: %d",
> +		atomic_read(&tcon->stats.cifs_stats.num_flushes));
> +	seq_printf(m, "\nLocks: %d HardLinks: %d Symlinks: %d",
> +		atomic_read(&tcon->stats.cifs_stats.num_locks),
> +		atomic_read(&tcon->stats.cifs_stats.num_hardlinks),
> +		atomic_read(&tcon->stats.cifs_stats.num_symlinks));
> +	seq_printf(m, "\nOpens: %d Closes: %d Deletes: %d",
> +		atomic_read(&tcon->stats.cifs_stats.num_opens),
> +		atomic_read(&tcon->stats.cifs_stats.num_closes),
> +		atomic_read(&tcon->stats.cifs_stats.num_deletes));
> +	seq_printf(m, "\nPosix Opens: %d Posix Mkdirs: %d",
> +		atomic_read(&tcon->stats.cifs_stats.num_posixopens),
> +		atomic_read(&tcon->stats.cifs_stats.num_posixmkdirs));
> +	seq_printf(m, "\nMkdirs: %d Rmdirs: %d",
> +		atomic_read(&tcon->stats.cifs_stats.num_mkdirs),
> +		atomic_read(&tcon->stats.cifs_stats.num_rmdirs));
> +	seq_printf(m, "\nRenames: %d T2 Renames %d",
> +		atomic_read(&tcon->stats.cifs_stats.num_renames),
> +		atomic_read(&tcon->stats.cifs_stats.num_t2renames));
> +	seq_printf(m, "\nFindFirst: %d FNext %d FClose %d",
> +		atomic_read(&tcon->stats.cifs_stats.num_ffirst),
> +		atomic_read(&tcon->stats.cifs_stats.num_fnext),
> +		atomic_read(&tcon->stats.cifs_stats.num_fclose));
> +}
> +
>  static int cifs_stats_proc_show(struct seq_file *m, void *v)
>  {
>  	int i;
> @@ -354,44 +423,7 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
>  						  tcon_list);
>  				i++;
>  				seq_printf(m, "\n%d) %s", i, tcon->treeName);
> -				if (tcon->need_reconnect)
> -					seq_puts(m, "\tDISCONNECTED ");
> -				seq_printf(m, "\nSMBs: %d Oplock Breaks: %d",
> -					atomic_read(&tcon->num_smbs_sent),
> -					atomic_read(&tcon->num_oplock_brks));
> -				seq_printf(m, "\nReads:  %d Bytes: %lld",
> -					atomic_read(&tcon->num_reads),
> -					(long long)(tcon->bytes_read));
> -				seq_printf(m, "\nWrites: %d Bytes: %lld",
> -					atomic_read(&tcon->num_writes),
> -					(long long)(tcon->bytes_written));
> -				seq_printf(m, "\nFlushes: %d",
> -					atomic_read(&tcon->num_flushes));
> -				seq_printf(m, "\nLocks: %d HardLinks: %d "
> -					      "Symlinks: %d",
> -					atomic_read(&tcon->num_locks),
> -					atomic_read(&tcon->num_hardlinks),
> -					atomic_read(&tcon->num_symlinks));
> -				seq_printf(m, "\nOpens: %d Closes: %d "
> -					      "Deletes: %d",
> -					atomic_read(&tcon->num_opens),
> -					atomic_read(&tcon->num_closes),
> -					atomic_read(&tcon->num_deletes));
> -				seq_printf(m, "\nPosix Opens: %d "
> -					      "Posix Mkdirs: %d",
> -					atomic_read(&tcon->num_posixopens),
> -					atomic_read(&tcon->num_posixmkdirs));
> -				seq_printf(m, "\nMkdirs: %d Rmdirs: %d",
> -					atomic_read(&tcon->num_mkdirs),
> -					atomic_read(&tcon->num_rmdirs));
> -				seq_printf(m, "\nRenames: %d T2 Renames %d",
> -					atomic_read(&tcon->num_renames),
> -					atomic_read(&tcon->num_t2renames));
> -				seq_printf(m, "\nFindFirst: %d FNext %d "
> -					      "FClose %d",
> -					atomic_read(&tcon->num_ffirst),
> -					atomic_read(&tcon->num_fnext),
> -					atomic_read(&tcon->num_fclose));
> +				cifs_stats_print(m, tcon);
>  			}
>  		}
>  	}
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 4c38b04..6dfc7ef 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -292,6 +292,7 @@ struct TCP_Server_Info {
>  	bool	sec_kerberos;		/* supports plain Kerberos */
>  	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
>  	bool	large_buf;		/* is current buffer large? */
> +	bool	is_smb2;		/* smb2 not cifs protocol negotiated */
>  	struct delayed_work	echo; /* echo ping workqueue job */
>  	struct kvec *iov;	/* reusable kvec array for receives */
>  	unsigned int nr_iov;	/* number of kvecs in array */
> @@ -392,6 +393,9 @@ struct cifs_ses {
>     negotiate one of the older LANMAN dialects */
>  #define CIFS_SES_LANMAN 8
>  #define CIFS_SES_SMB2 16
> +
> +#define NUMBER_OF_SMB2_COMMANDS 0x0013
> +
>  /*
>   * there is one of these for each connection to a resource on a particular
>   * session
> @@ -409,27 +413,37 @@ struct cifs_tcon {
>  	enum statusEnum tidStatus;
>  #ifdef CONFIG_CIFS_STATS
>  	atomic_t num_smbs_sent;
> -	atomic_t num_writes;
> -	atomic_t num_reads;
> -	atomic_t num_flushes;
> -	atomic_t num_oplock_brks;
> -	atomic_t num_opens;
> -	atomic_t num_closes;
> -	atomic_t num_deletes;
> -	atomic_t num_mkdirs;
> -	atomic_t num_posixopens;
> -	atomic_t num_posixmkdirs;
> -	atomic_t num_rmdirs;
> -	atomic_t num_renames;
> -	atomic_t num_t2renames;
> -	atomic_t num_ffirst;
> -	atomic_t num_fnext;
> -	atomic_t num_fclose;
> -	atomic_t num_hardlinks;
> -	atomic_t num_symlinks;
> -	atomic_t num_locks;
> -	atomic_t num_acl_get;
> -	atomic_t num_acl_set;
> +	union {
> +		struct {
> +			atomic_t num_writes;
> +			atomic_t num_reads;
> +			atomic_t num_flushes;
> +			atomic_t num_oplock_brks;
> +			atomic_t num_opens;
> +			atomic_t num_closes;
> +			atomic_t num_deletes;
> +			atomic_t num_mkdirs;
> +			atomic_t num_posixopens;
> +			atomic_t num_posixmkdirs;
> +			atomic_t num_rmdirs;
> +			atomic_t num_renames;
> +			atomic_t num_t2renames;
> +			atomic_t num_ffirst;
> +			atomic_t num_fnext;
> +			atomic_t num_fclose;
> +			atomic_t num_hardlinks;
> +			atomic_t num_symlinks;
> +			atomic_t num_locks;
> +			atomic_t num_acl_get;
> +			atomic_t num_acl_set;
> +		} cifs_stats;
> +#ifdef CONFIG_CIFS_SMB2
> +		struct {
> +			atomic_t smb2_com_sent[NUMBER_OF_SMB2_COMMANDS];
> +			atomic_t smb2_com_fail[NUMBER_OF_SMB2_COMMANDS];
> +		} smb2_stats;

Is it really necessary to do this with atomics? Those can have
significant performance impact (TLB flushes, and we don't seem to need the
guarantees that they provide for simple counters like this. Perhaps
these should be switched to per-cpu variables or just plain ints?

> +#endif /* CONFIG CIFS_SMB2 */
> +	} stats;
>  #ifdef CONFIG_CIFS_STATS2
>  	unsigned long long time_writes;
>  	unsigned long long time_reads;
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index ea7b813..4e11051 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -867,7 +867,7 @@ PsxDelete:
>  		cFYI(1, "Posix delete returned %d", rc);
>  	cifs_buf_release(pSMB);
>  
> -	cifs_stats_inc(&tcon->num_deletes);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_deletes);
>  
>  	if (rc == -EAGAIN)
>  		goto PsxDelete;
> @@ -909,7 +909,7 @@ DelFileRetry:
>  	pSMB->ByteCount = cpu_to_le16(name_len + 1);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> -	cifs_stats_inc(&tcon->num_deletes);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_deletes);
>  	if (rc)
>  		cFYI(1, "Error in RMFile = %d", rc);
>  
> @@ -953,7 +953,7 @@ RmDirRetry:
>  	pSMB->ByteCount = cpu_to_le16(name_len + 1);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> -	cifs_stats_inc(&tcon->num_rmdirs);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_rmdirs);
>  	if (rc)
>  		cFYI(1, "Error in RMDir = %d", rc);
>  
> @@ -996,7 +996,7 @@ MkDirRetry:
>  	pSMB->ByteCount = cpu_to_le16(name_len + 1);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> -	cifs_stats_inc(&tcon->num_mkdirs);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_mkdirs);
>  	if (rc)
>  		cFYI(1, "Error in Mkdir = %d", rc);
>  
> @@ -1118,9 +1118,9 @@ psx_create_err:
>  	cifs_buf_release(pSMB);
>  
>  	if (posix_flags & SMB_O_DIRECTORY)
> -		cifs_stats_inc(&tcon->num_posixmkdirs);
> +		cifs_stats_inc(&tcon->stats.cifs_stats.num_posixmkdirs);
>  	else
> -		cifs_stats_inc(&tcon->num_posixopens);
> +		cifs_stats_inc(&tcon->stats.cifs_stats.num_posixopens);
>  
>  	if (rc == -EAGAIN)
>  		goto PsxCreat;
> @@ -1241,7 +1241,7 @@ OldOpenRetry:
>  	/* long_op set to 1 to allow for oplock break timeouts */
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			(struct smb_hdr *)pSMBr, &bytes_returned, 0);
> -	cifs_stats_inc(&tcon->num_opens);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_opens);
>  	if (rc) {
>  		cFYI(1, "Error in Open = %d", rc);
>  	} else {
> @@ -1354,7 +1354,7 @@ openRetry:
>  	/* long_op set to 1 to allow for oplock break timeouts */
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			(struct smb_hdr *)pSMBr, &bytes_returned, 0);
> -	cifs_stats_inc(&tcon->num_opens);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_opens);
>  	if (rc) {
>  		cFYI(1, "Error in Open = %d", rc);
>  	} else {
> @@ -1728,7 +1728,7 @@ cifs_async_readv(struct cifs_readdata *rdata)
>  			     rdata, false);
>  
>  	if (rc == 0)
> -		cifs_stats_inc(&tcon->num_reads);
> +		cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
>  
>  	cifs_small_buf_release(smb);
>  	return rc;
> @@ -1796,7 +1796,7 @@ CIFSSMBRead(const int xid, struct cifs_io_parms *io_parms, unsigned int *nbytes,
>  	iov[0].iov_len = be32_to_cpu(pSMB->hdr.smb_buf_length) + 4;
>  	rc = SendReceive2(xid, tcon->ses, iov, 1 /* num iovecs */,
>  			 &resp_buf_type, CIFS_LOG_ERROR);
> -	cifs_stats_inc(&tcon->num_reads);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
>  	pSMBr = (READ_RSP *)iov[0].iov_base;
>  	if (rc) {
>  		cERROR(1, "Send error in read = %d", rc);
> @@ -1948,7 +1948,7 @@ CIFSSMBWrite(const int xid, struct cifs_io_parms *io_parms,
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, long_op);
> -	cifs_stats_inc(&tcon->num_writes);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
>  	if (rc) {
>  		cFYI(1, "Send error in write = %d", rc);
>  	} else {
> @@ -2197,7 +2197,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
>  			     NULL, cifs_writev_callback, wdata, false);
>  
>  	if (rc == 0)
> -		cifs_stats_inc(&tcon->num_writes);
> +		cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
>  	else
>  		kref_put(&wdata->refcount, cifs_writedata_release);
>  
> @@ -2287,7 +2287,7 @@ CIFSSMBWrite2(const int xid, struct cifs_io_parms *io_parms,
>  
>  	rc = SendReceive2(xid, tcon->ses, iov, n_vec + 1, &resp_buf_type,
>  			  long_op);
> -	cifs_stats_inc(&tcon->num_writes);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
>  	if (rc) {
>  		cFYI(1, "Send error Write2 = %d", rc);
>  	} else if (resp_buf_type == 0) {
> @@ -2353,7 +2353,7 @@ int cifs_lockv(const int xid, struct cifs_tcon *tcon, const __u16 netfid,
>  	iov[1].iov_base = (char *)buf;
>  	iov[1].iov_len = (num_unlock + num_lock) * sizeof(LOCKING_ANDX_RANGE);
>  
> -	cifs_stats_inc(&tcon->num_locks);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
>  	rc = SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type, CIFS_NO_RESP);
>  	if (rc)
>  		cFYI(1, "Send error in cifs_lockv = %d", rc);
> @@ -2422,7 +2422,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
>  				      timeout);
>  		/* SMB buffer freed by function above */
>  	}
> -	cifs_stats_inc(&tcon->num_locks);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
>  	if (rc)
>  		cFYI(1, "Send error in Lock = %d", rc);
>  
> @@ -2587,7 +2587,7 @@ CIFSSMBClose(const int xid, struct cifs_tcon *tcon, int smb_file_id)
>  	pSMB->LastWriteTime = 0xFFFFFFFF;
>  	pSMB->ByteCount = 0;
>  	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
> -	cifs_stats_inc(&tcon->num_closes);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_closes);
>  	if (rc) {
>  		if (rc != -EINTR) {
>  			/* EINTR is expected when user ctl-c to kill app */
> @@ -2616,7 +2616,7 @@ CIFSSMBFlush(const int xid, struct cifs_tcon *tcon, int smb_file_id)
>  	pSMB->FileID = (__u16) smb_file_id;
>  	pSMB->ByteCount = 0;
>  	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
> -	cifs_stats_inc(&tcon->num_flushes);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_flushes);
>  	if (rc)
>  		cERROR(1, "Send error in Flush = %d", rc);
>  
> @@ -2679,7 +2679,7 @@ renameRetry:
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> -	cifs_stats_inc(&tcon->num_renames);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_renames);
>  	if (rc)
>  		cFYI(1, "Send error in rename = %d", rc);
>  
> @@ -2758,7 +2758,7 @@ int CIFSSMBRenameOpenFile(const int xid, struct cifs_tcon *pTcon,
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  	rc = SendReceive(xid, pTcon->ses, (struct smb_hdr *) pSMB,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> -	cifs_stats_inc(&pTcon->num_t2renames);
> +	cifs_stats_inc(&pTcon->stats.cifs_stats.num_t2renames);
>  	if (rc)
>  		cFYI(1, "Send error in Rename (by file handle) = %d", rc);
>  
> @@ -2915,7 +2915,7 @@ createSymLinkRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> -	cifs_stats_inc(&tcon->num_symlinks);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_symlinks);
>  	if (rc)
>  		cFYI(1, "Send error in SetPathInfo create symlink = %d", rc);
>  
> @@ -3001,7 +3001,7 @@ createHardLinkRetry:
>  	pSMB->ByteCount = cpu_to_le16(byte_count);
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> -	cifs_stats_inc(&tcon->num_hardlinks);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_hardlinks);
>  	if (rc)
>  		cFYI(1, "Send error in SetPathInfo (hard link) = %d", rc);
>  
> @@ -3073,7 +3073,7 @@ winCreateHardLinkRetry:
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> -	cifs_stats_inc(&tcon->num_hardlinks);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_hardlinks);
>  	if (rc)
>  		cFYI(1, "Send error in hard link (NT rename) = %d", rc);
>  
> @@ -3490,7 +3490,7 @@ queryAclRetry:
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
> -	cifs_stats_inc(&tcon->num_acl_get);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_acl_get);
>  	if (rc) {
>  		cFYI(1, "Send error in Query POSIX ACL = %d", rc);
>  	} else {
> @@ -3801,7 +3801,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifs_tcon *tcon, __u16 fid,
>  
>  	rc = SendReceive2(xid, tcon->ses, iov, 1 /* num iovec */, &buf_type,
>  			 0);
> -	cifs_stats_inc(&tcon->num_acl_get);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_acl_get);
>  	if (rc) {
>  		cFYI(1, "Send error in QuerySecDesc = %d", rc);
>  	} else {                /* decode response */
> @@ -4405,7 +4405,7 @@ findFirstRetry:
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> -	cifs_stats_inc(&tcon->num_ffirst);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_ffirst);
>  
>  	if (rc) {/* BB add logic to retry regular search if Unix search
>  			rejected unexpectedly by server */
> @@ -4532,7 +4532,7 @@ int CIFSFindNext(const int xid, struct cifs_tcon *tcon,
>  
>  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>  			(struct smb_hdr *) pSMBr, &bytes_returned, 0);
> -	cifs_stats_inc(&tcon->num_fnext);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_fnext);
>  	if (rc) {
>  		if (rc == -EBADF) {
>  			psrch_inf->endOfSearch = true;
> @@ -4623,7 +4623,7 @@ CIFSFindClose(const int xid, struct cifs_tcon *tcon,
>  	if (rc)
>  		cERROR(1, "Send error in FindClose = %d", rc);
>  
> -	cifs_stats_inc(&tcon->num_fclose);
> +	cifs_stats_inc(&tcon->stats.cifs_stats.num_fclose);
>  
>  	/* Since session is dead, search handle closed on server already */
>  	if (rc == -EAGAIN)
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 703ef5c..1934575 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -571,7 +571,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
>  			if (tcon->tid != buf->Tid)
>  				continue;
>  
> -			cifs_stats_inc(&tcon->num_oplock_brks);
> +			cifs_stats_inc(&tcon->stats.cifs_stats.num_oplock_brks);
>  			spin_lock(&cifs_file_list_lock);
>  			list_for_each(tmp2, &tcon->openFileList) {
>  				netfile = list_entry(tmp2, struct cifsFileInfo,


-- 
Jeff Layton <jlayton@samba.org>
