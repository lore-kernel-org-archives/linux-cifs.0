From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH] cifs: convert cifs_tcp_ses_lock from a rwlock to a
 spinlock
Date: Mon, 18 Oct 2010 14:29:14 -0400
Message-ID: <20101018142914.0c1e11ee@corrin.poochiereds.net>
References: <4CBC8B09.2050702@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CBC8B09.2050702-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 18 Oct 2010 23:29:37 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> cifs_tcp_ses_lock is a rwlock with protects the cifs_tcp_ses_list,
> server->smb_ses_list and the ses->tcon_list. It also protects a few
> ref counters in server, ses and tcon. In most cases the critical section
> doesn't seem to be large, in a few cases where it is slightly large, there
> seem to be really no benefit from concurrent access. I briefly considered RCU
> mechanism but it appears to me that there is no real need.
> 
> Replace it with a spinlock and get rid of the last rwlock in the cifs code.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/cifs_debug.c |   12 ++++----
>  fs/cifs/cifsfs.c     |    8 +++---
>  fs/cifs/cifsglob.h   |    2 +-
>  fs/cifs/cifssmb.c    |    6 ++--
>  fs/cifs/connect.c    |   70 +++++++++++++++++++++++++-------------------------
>  fs/cifs/misc.c       |   14 +++++-----
>  fs/cifs/sess.c       |    4 +-
>  7 files changed, 58 insertions(+), 58 deletions(-)
> 
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index eb1ba49..103ab8b 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -148,7 +148,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>  	seq_printf(m, "Servers:");
>  
>  	i = 0;
> -	read_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	list_for_each(tmp1, &cifs_tcp_ses_list) {
>  		server = list_entry(tmp1, struct TCP_Server_Info,
>  				    tcp_ses_list);
> @@ -230,7 +230,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>  			spin_unlock(&GlobalMid_Lock);
>  		}
>  	}
> -	read_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  	seq_putc(m, '\n');
>  
>  	/* BB add code to dump additional info such as TCP session info now */
> @@ -270,7 +270,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
>  		atomic_set(&totBufAllocCount, 0);
>  		atomic_set(&totSmBufAllocCount, 0);
>  #endif /* CONFIG_CIFS_STATS2 */
> -		read_lock(&cifs_tcp_ses_lock);
> +		spin_lock(&cifs_tcp_ses_lock);
>  		list_for_each(tmp1, &cifs_tcp_ses_list) {
>  			server = list_entry(tmp1, struct TCP_Server_Info,
>  					    tcp_ses_list);
> @@ -303,7 +303,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
>  				}
>  			}
>  		}
> -		read_unlock(&cifs_tcp_ses_lock);
> +		spin_unlock(&cifs_tcp_ses_lock);
>  	}
>  
>  	return count;
> @@ -343,7 +343,7 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
>  		GlobalCurrentXid, GlobalMaxActiveXid);
>  
>  	i = 0;
> -	read_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	list_for_each(tmp1, &cifs_tcp_ses_list) {
>  		server = list_entry(tmp1, struct TCP_Server_Info,
>  				    tcp_ses_list);
> @@ -397,7 +397,7 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
>  			}
>  		}
>  	}
> -	read_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	seq_putc(m, '\n');
>  	return 0;
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index f1d9c71..cb77915 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -482,16 +482,16 @@ static void cifs_umount_begin(struct super_block *sb)
>  
>  	tcon = cifs_sb_master_tcon(cifs_sb);
>  
> -	read_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	if ((tcon->tc_count > 1) || (tcon->tidStatus == CifsExiting)) {
>  		/* we have other mounts to same share or we have
>  		   already tried to force umount this and woken up
>  		   all waiting network requests, nothing to do */
> -		read_unlock(&cifs_tcp_ses_lock);
> +		spin_unlock(&cifs_tcp_ses_lock);
>  		return;
>  	} else if (tcon->tc_count == 1)
>  		tcon->tidStatus = CifsExiting;
> -	read_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
>  	/* cancel_notify_requests(tcon); */
> @@ -940,7 +940,7 @@ init_cifs(void)
>  	GlobalTotalActiveXid = 0;
>  	GlobalMaxActiveXid = 0;
>  	memset(Local_System_Name, 0, 15);
> -	rwlock_init(&cifs_tcp_ses_lock);
> +	spin_lock_init(&cifs_tcp_ses_lock);
>  	spin_lock_init(&cifs_file_list_lock);
>  	spin_lock_init(&GlobalMid_Lock);
>  
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 18ee0ad..28337cb 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -703,7 +703,7 @@ GLOBAL_EXTERN struct list_head		cifs_tcp_ses_list;
>   * the reference counters for the server, smb session, and tcon. Finally,
>   * changes to the tcon->tidStatus should be done while holding this lock.
>   */
> -GLOBAL_EXTERN rwlock_t		cifs_tcp_ses_lock;
> +GLOBAL_EXTERN spinlock_t		cifs_tcp_ses_lock;
>  
>  /*
>   * This lock protects the cifs_file->llist and cifs_file->flist
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index bfb59a6..e98f1f3 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -593,9 +593,9 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>  			rc = -EIO;
>  			goto neg_err_exit;
>  		}
> -		read_lock(&cifs_tcp_ses_lock);
> +		spin_lock(&cifs_tcp_ses_lock);
>  		if (server->srv_count > 1) {
> -			read_unlock(&cifs_tcp_ses_lock);
> +			spin_unlock(&cifs_tcp_ses_lock);
>  			if (memcmp(server->server_GUID,
>  				   pSMBr->u.extended_response.
>  				   GUID, 16) != 0) {
> @@ -605,7 +605,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
>  					16);
>  			}
>  		} else {
> -			read_unlock(&cifs_tcp_ses_lock);
> +			spin_unlock(&cifs_tcp_ses_lock);
>  			memcpy(server->server_GUID,
>  			       pSMBr->u.extended_response.GUID, 16);
>  		}
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 019f003..7e73176 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -150,7 +150,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>  
>  	/* before reconnecting the tcp session, mark the smb session (uid)
>  		and the tid bad so they are not used until reconnected */
> -	read_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	list_for_each(tmp, &server->smb_ses_list) {
>  		ses = list_entry(tmp, struct cifsSesInfo, smb_ses_list);
>  		ses->need_reconnect = true;
> @@ -160,7 +160,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>  			tcon->need_reconnect = true;
>  		}
>  	}
> -	read_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  	/* do not want to be sending data on a socket we are freeing */
>  	mutex_lock(&server->srv_mutex);
>  	if (server->ssocket) {
> @@ -637,9 +637,9 @@ multi_t2_fnd:
>  	} /* end while !EXITING */
>  
>  	/* take it off the list, if it's not already */
> -	write_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	list_del_init(&server->tcp_ses_list);
> -	write_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	spin_lock(&GlobalMid_Lock);
>  	server->tcpStatus = CifsExiting;
> @@ -677,7 +677,7 @@ multi_t2_fnd:
>  	 * BB: we shouldn't have to do any of this. It shouldn't be
>  	 * possible to exit from the thread with active SMB sessions
>  	 */
> -	read_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	if (list_empty(&server->pending_mid_q)) {
>  		/* loop through server session structures attached to this and
>  		    mark them dead */
> @@ -687,7 +687,7 @@ multi_t2_fnd:
>  			ses->status = CifsExiting;
>  			ses->server = NULL;
>  		}
> -		read_unlock(&cifs_tcp_ses_lock);
> +		spin_unlock(&cifs_tcp_ses_lock);
>  	} else {
>  		/* although we can not zero the server struct pointer yet,
>  		since there are active requests which may depnd on them,
> @@ -710,7 +710,7 @@ multi_t2_fnd:
>  			}
>  		}
>  		spin_unlock(&GlobalMid_Lock);
> -		read_unlock(&cifs_tcp_ses_lock);
> +		spin_unlock(&cifs_tcp_ses_lock);
>  		/* 1/8th of sec is more than enough time for them to exit */
>  		msleep(125);
>  	}
> @@ -733,12 +733,12 @@ multi_t2_fnd:
>  	if a crazy root user tried to kill cifsd
>  	kernel thread explicitly this might happen) */
>  	/* BB: This shouldn't be necessary, see above */
> -	read_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	list_for_each(tmp, &server->smb_ses_list) {
>  		ses = list_entry(tmp, struct cifsSesInfo, smb_ses_list);
>  		ses->server = NULL;
>  	}
> -	read_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	kfree(server->hostname);
>  	task_to_wake = xchg(&server->tsk, NULL);
> @@ -1524,7 +1524,7 @@ cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
>  {
>  	struct TCP_Server_Info *server;
>  
> -	write_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
>  		if (!match_address(server, addr,
>  				   (struct sockaddr *)&vol->srcaddr))
> @@ -1534,11 +1534,11 @@ cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
>  			continue;
>  
>  		++server->srv_count;
> -		write_unlock(&cifs_tcp_ses_lock);
> +		spin_unlock(&cifs_tcp_ses_lock);
>  		cFYI(1, "Existing tcp session with server found");
>  		return server;
>  	}
> -	write_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  	return NULL;
>  }
>  
> @@ -1547,14 +1547,14 @@ cifs_put_tcp_session(struct TCP_Server_Info *server)
>  {
>  	struct task_struct *task;
>  
> -	write_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	if (--server->srv_count > 0) {
> -		write_unlock(&cifs_tcp_ses_lock);
> +		spin_unlock(&cifs_tcp_ses_lock);
>  		return;
>  	}
>  
>  	list_del_init(&server->tcp_ses_list);
> -	write_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	spin_lock(&GlobalMid_Lock);
>  	server->tcpStatus = CifsExiting;
> @@ -1679,9 +1679,9 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>  	}
>  
>  	/* thread spawned, put it on the list */
> -	write_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	list_add(&tcp_ses->tcp_ses_list, &cifs_tcp_ses_list);
> -	write_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	cifs_fscache_get_client_cookie(tcp_ses);
>  
> @@ -1703,7 +1703,7 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
>  {
>  	struct cifsSesInfo *ses;
>  
> -	write_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
>  		switch (server->secType) {
>  		case Kerberos:
> @@ -1723,10 +1723,10 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
>  				continue;
>  		}
>  		++ses->ses_count;
> -		write_unlock(&cifs_tcp_ses_lock);
> +		spin_unlock(&cifs_tcp_ses_lock);
>  		return ses;
>  	}
> -	write_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  	return NULL;
>  }
>  
> @@ -1737,14 +1737,14 @@ cifs_put_smb_ses(struct cifsSesInfo *ses)
>  	struct TCP_Server_Info *server = ses->server;
>  
>  	cFYI(1, "%s: ses_count=%d\n", __func__, ses->ses_count);
> -	write_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	if (--ses->ses_count > 0) {
> -		write_unlock(&cifs_tcp_ses_lock);
> +		spin_unlock(&cifs_tcp_ses_lock);
>  		return;
>  	}
>  
>  	list_del_init(&ses->smb_ses_list);
> -	write_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	if (ses->status == CifsGood) {
>  		xid = GetXid();
> @@ -1841,9 +1841,9 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
>  		goto get_ses_fail;
>  
>  	/* success, put it on the list */
> -	write_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	list_add(&ses->smb_ses_list, &server->smb_ses_list);
> -	write_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	FreeXid(xid);
>  	return ses;
> @@ -1860,7 +1860,7 @@ cifs_find_tcon(struct cifsSesInfo *ses, const char *unc)
>  	struct list_head *tmp;
>  	struct cifsTconInfo *tcon;
>  
> -	write_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	list_for_each(tmp, &ses->tcon_list) {
>  		tcon = list_entry(tmp, struct cifsTconInfo, tcon_list);
>  		if (tcon->tidStatus == CifsExiting)
> @@ -1869,10 +1869,10 @@ cifs_find_tcon(struct cifsSesInfo *ses, const char *unc)
>  			continue;
>  
>  		++tcon->tc_count;
> -		write_unlock(&cifs_tcp_ses_lock);
> +		spin_unlock(&cifs_tcp_ses_lock);
>  		return tcon;
>  	}
> -	write_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  	return NULL;
>  }
>  
> @@ -1883,14 +1883,14 @@ cifs_put_tcon(struct cifsTconInfo *tcon)
>  	struct cifsSesInfo *ses = tcon->ses;
>  
>  	cFYI(1, "%s: tc_count=%d\n", __func__, tcon->tc_count);
> -	write_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	if (--tcon->tc_count > 0) {
> -		write_unlock(&cifs_tcp_ses_lock);
> +		spin_unlock(&cifs_tcp_ses_lock);
>  		return;
>  	}
>  
>  	list_del_init(&tcon->tcon_list);
> -	write_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	xid = GetXid();
>  	CIFSSMBTDis(xid, tcon);
> @@ -1963,9 +1963,9 @@ cifs_get_tcon(struct cifsSesInfo *ses, struct smb_vol *volume_info)
>  	tcon->nocase = volume_info->nocase;
>  	tcon->local_lease = volume_info->local_lease;
>  
> -	write_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	list_add(&tcon->tcon_list, &ses->tcon_list);
> -	write_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	cifs_fscache_get_super_cookie(tcon);
>  
> @@ -3225,9 +3225,9 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
>  	vol_info->secFlg = CIFSSEC_MUST_KRB5;
>  
>  	/* get a reference for the same TCP session */
> -	write_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	++master_tcon->ses->server->srv_count;
> -	write_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	ses = cifs_get_smb_ses(master_tcon->ses->server, vol_info);
>  	if (IS_ERR(ses)) {
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index de6073c..a7b492c 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -347,7 +347,7 @@ header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
>  				if (current_fsuid() != treeCon->ses->linux_uid) {
>  					cFYI(1, "Multiuser mode and UID "
>  						 "did not match tcon uid");
> -					read_lock(&cifs_tcp_ses_lock);
> +					spin_lock(&cifs_tcp_ses_lock);
>  					list_for_each(temp_item, &treeCon->ses->server->smb_ses_list) {
>  						ses = list_entry(temp_item, struct cifsSesInfo, smb_ses_list);
>  						if (ses->linux_uid == current_fsuid()) {
> @@ -361,7 +361,7 @@ header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
>  							}
>  						}
>  					}
> -					read_unlock(&cifs_tcp_ses_lock);
> +					spin_unlock(&cifs_tcp_ses_lock);
>  				}
>  			}
>  		}
> @@ -551,7 +551,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
>  		return false;
>  
>  	/* look up tcon based on tid & uid */
> -	read_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	list_for_each(tmp, &srv->smb_ses_list) {
>  		ses = list_entry(tmp, struct cifsSesInfo, smb_ses_list);
>  		list_for_each(tmp1, &ses->tcon_list) {
> @@ -573,7 +573,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
>  				 */
>  				if (netfile->closePend) {
>  					spin_unlock(&cifs_file_list_lock);
> -					read_unlock(&cifs_tcp_ses_lock);
> +					spin_unlock(&cifs_tcp_ses_lock);
>  					return true;
>  				}
>  
> @@ -595,16 +595,16 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
>  				netfile->oplock_break_cancelled = false;
>  
>  				spin_unlock(&cifs_file_list_lock);
> -				read_unlock(&cifs_tcp_ses_lock);
> +				spin_unlock(&cifs_tcp_ses_lock);
>  				return true;
>  			}
>  			spin_unlock(&cifs_file_list_lock);
> -			read_unlock(&cifs_tcp_ses_lock);
> +			spin_unlock(&cifs_tcp_ses_lock);
>  			cFYI(1, "No matching file for oplock break");
>  			return true;
>  		}
>  	}
> -	read_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  	cFYI(1, "Can not process oplock break for non-existent connection");
>  	return true;
>  }
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 2111bed..933ed26 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -80,7 +80,7 @@ static __le16 get_next_vcnum(struct cifsSesInfo *ses)
>  	if (max_vcs < 2)
>  		max_vcs = 0xFFFF;
>  
> -	write_lock(&cifs_tcp_ses_lock);
> +	spin_lock(&cifs_tcp_ses_lock);
>  	if ((ses->need_reconnect) && is_first_ses_reconnect(ses))
>  			goto get_vc_num_exit;  /* vcnum will be zero */
>  	for (i = ses->server->srv_count - 1; i < max_vcs; i++) {
> @@ -112,7 +112,7 @@ static __le16 get_next_vcnum(struct cifsSesInfo *ses)
>  		vcnum = i;
>  	ses->vcnum = vcnum;
>  get_vc_num_exit:
> -	write_unlock(&cifs_tcp_ses_lock);
> +	spin_unlock(&cifs_tcp_ses_lock);
>  
>  	return cpu_to_le16(vcnum);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Looks reasonable. These codepaths aren't terribly "hot", so this lock
is fairly low-contention anyway.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
