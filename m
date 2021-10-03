Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CE5C433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 01:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B1F461178
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 01:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbhJCBX3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 21:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229486AbhJCBX3 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Oct 2021 21:23:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01797611EF
        for <linux-cifs@vger.kernel.org>; Sun,  3 Oct 2021 01:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633224103;
        bh=JmwsxQqfj7XAiPp4fDNAKctZgdoJIaQMM1YgcmsZMXQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=D4m7tmgJZHh+FGpE+zHYCu/MhIjAXnJcePdqiNAx1G/nLGsxb3Wli3PHHzryq8Z9b
         fFzU0r/Wa6UGHxfmnUW+UCSxIu9rmfuKrzfaxlmmLzgUUhGPbUq5WW1Y3tW++TZWjU
         ar6wSQKKtVGYC9J9qp4FfKmgVTL+T2KxTEJUnTKKKsdLbehJzXCh1+PRXQL1mxzYpR
         FeXfGW6ATioJvBzhEo1meMmFB3RFgGcoMKH9YXVZuc9JTQCZ2GRz7TO/6kbkBav6CQ
         57MkepNSFdjSuHVGvPuB4aDeHLyOEaWSOT4Dp6EaHNAtE7TjtQFOMHivCK8ybTAR2W
         Dv2A4ai8y15vQ==
Received: by mail-oi1-f174.google.com with SMTP id n64so16750140oih.2
        for <linux-cifs@vger.kernel.org>; Sat, 02 Oct 2021 18:21:42 -0700 (PDT)
X-Gm-Message-State: AOAM531YzCPEVF+dHJEVi1LjxuS2Kgc1Gy3OFpvOXPNpwQ7F2+nvCICY
        l/+za/TrjMwFMcz5b9cL7rJp1c67rS1O3GQuM7E=
X-Google-Smtp-Source: ABdhPJwYLVXjJd+bgGlc3Psa4oMSMZuuxVBSBMXroZLqCFU+CMO1iI9jdULtZ05zIgx3m/YuAnOlZpy9KOeOyWiyPas=
X-Received: by 2002:a05:6808:1a29:: with SMTP id bk41mr9117990oib.167.1633224102276;
 Sat, 02 Oct 2021 18:21:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Sat, 2 Oct 2021 18:21:41 -0700 (PDT)
In-Reply-To: <20211002131212.130629-3-slow@samba.org>
References: <20211002131212.130629-1-slow@samba.org> <20211002131212.130629-3-slow@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 3 Oct 2021 10:21:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Qz6TXcA8eyfaQ4qW7-3M29LixVcWurSnz43r0znJgGQ@mail.gmail.com>
Message-ID: <CAKYAXd_Qz6TXcA8eyfaQ4qW7-3M29LixVcWurSnz43r0znJgGQ@mail.gmail.com>
Subject: Re: [PATCH v6 02/14] ksmbd: add validation in smb2_ioctl
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-02 22:12 GMT+09:00, Ralph Boehme <slow@samba.org>:
> From: Namjae Jeon <linkinjeon@kernel.org>
>
> Add validation for request/response buffer size check in smb2_ioctl and
> fsctl_copychunk() take copychunk_ioctl_req pointer and the other argument=
s
> instead of smb2_ioctl_req structure and remove an unused smb2_ioctl_req
> argument of fsctl_validate_negotiate_info.
>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
If you don't find any issue in this patch, please mark your reviewed-by tag=
.
Other patches also..

Thanks!

> ---
>  fs/ksmbd/smb2pdu.c | 105 ++++++++++++++++++++++++++++++++++-----------
>  fs/ksmbd/vfs.c     |   2 +-
>  fs/ksmbd/vfs.h     |   2 +-
>  3 files changed, 83 insertions(+), 26 deletions(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index dcf907738610..3476cacd2784 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -7044,24 +7044,26 @@ int smb2_lock(struct ksmbd_work *work)
>  	return err;
>  }
>
> -static int fsctl_copychunk(struct ksmbd_work *work, struct smb2_ioctl_re=
q
> *req,
> +static int fsctl_copychunk(struct ksmbd_work *work,
> +			   struct copychunk_ioctl_req *ci_req,
> +			   unsigned int cnt_code,
> +			   unsigned int input_count,
> +			   unsigned long long volatile_id,
> +			   unsigned long long persistent_id,
>  			   struct smb2_ioctl_rsp *rsp)
>  {
> -	struct copychunk_ioctl_req *ci_req;
>  	struct copychunk_ioctl_rsp *ci_rsp;
>  	struct ksmbd_file *src_fp =3D NULL, *dst_fp =3D NULL;
>  	struct srv_copychunk *chunks;
>  	unsigned int i, chunk_count, chunk_count_written =3D 0;
>  	unsigned int chunk_size_written =3D 0;
>  	loff_t total_size_written =3D 0;
> -	int ret, cnt_code;
> +	int ret =3D 0;
>
> -	cnt_code =3D le32_to_cpu(req->CntCode);
> -	ci_req =3D (struct copychunk_ioctl_req *)&req->Buffer[0];
>  	ci_rsp =3D (struct copychunk_ioctl_rsp *)&rsp->Buffer[0];
>
> -	rsp->VolatileFileId =3D req->VolatileFileId;
> -	rsp->PersistentFileId =3D req->PersistentFileId;
> +	rsp->VolatileFileId =3D cpu_to_le64(volatile_id);
> +	rsp->PersistentFileId =3D cpu_to_le64(persistent_id);
>  	ci_rsp->ChunksWritten =3D
>  		cpu_to_le32(ksmbd_server_side_copy_max_chunk_count());
>  	ci_rsp->ChunkBytesWritten =3D
> @@ -7071,12 +7073,13 @@ static int fsctl_copychunk(struct ksmbd_work *wor=
k,
> struct smb2_ioctl_req *req,
>
>  	chunks =3D (struct srv_copychunk *)&ci_req->Chunks[0];
>  	chunk_count =3D le32_to_cpu(ci_req->ChunkCount);
> +	if (chunk_count =3D=3D 0)
> +		goto out;
>  	total_size_written =3D 0;
>
>  	/* verify the SRV_COPYCHUNK_COPY packet */
>  	if (chunk_count > ksmbd_server_side_copy_max_chunk_count() ||
> -	    le32_to_cpu(req->InputCount) <
> -	     offsetof(struct copychunk_ioctl_req, Chunks) +
> +	    input_count < offsetof(struct copychunk_ioctl_req, Chunks) +
>  	     chunk_count * sizeof(struct srv_copychunk)) {
>  		rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
>  		return -EINVAL;
> @@ -7097,9 +7100,7 @@ static int fsctl_copychunk(struct ksmbd_work *work,
> struct smb2_ioctl_req *req,
>
>  	src_fp =3D ksmbd_lookup_foreign_fd(work,
>  					 le64_to_cpu(ci_req->ResumeKey[0]));
> -	dst_fp =3D ksmbd_lookup_fd_slow(work,
> -				      le64_to_cpu(req->VolatileFileId),
> -				      le64_to_cpu(req->PersistentFileId));
> +	dst_fp =3D ksmbd_lookup_fd_slow(work, volatile_id, persistent_id);
>  	ret =3D -EINVAL;
>  	if (!src_fp ||
>  	    src_fp->persistent_id !=3D le64_to_cpu(ci_req->ResumeKey[1])) {
> @@ -7174,11 +7175,11 @@ static __be32 idev_ipv4_address(struct in_device
> *idev)
>  }
>
>  static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
> -					struct smb2_ioctl_req *req,
> -					struct smb2_ioctl_rsp *rsp)
> +					struct smb2_ioctl_rsp *rsp,
> +					unsigned int out_buf_len)
>  {
>  	struct network_interface_info_ioctl_rsp *nii_rsp =3D NULL;
> -	int nbytes =3D 0;
> +	unsigned int nbytes =3D 0;
>  	struct net_device *netdev;
>  	struct sockaddr_storage_rsp *sockaddr_storage;
>  	unsigned int flags;
> @@ -7187,6 +7188,10 @@ static int fsctl_query_iface_info_ioctl(struct
> ksmbd_conn *conn,
>
>  	rtnl_lock();
>  	for_each_netdev(&init_net, netdev) {
> +		if (out_buf_len <
> +		    nbytes + sizeof(struct network_interface_info_ioctl_rsp))
> +			break;
> +
>  		if (netdev->type =3D=3D ARPHRD_LOOPBACK)
>  			continue;
>
> @@ -7258,6 +7263,8 @@ static int fsctl_query_iface_info_ioctl(struct
> ksmbd_conn *conn,
>  			sockaddr_storage->addr6.ScopeId =3D 0;
>  		}
>
> +		if (out_buf_len - nbytes < sizeof(struct
> network_interface_info_ioctl_rsp))
> +			break;
>  		nbytes +=3D sizeof(struct network_interface_info_ioctl_rsp);
>  	}
>  	rtnl_unlock();
> @@ -7278,11 +7285,16 @@ static int fsctl_query_iface_info_ioctl(struct
> ksmbd_conn *conn,
>
>  static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
>  					 struct validate_negotiate_info_req *neg_req,
> -					 struct validate_negotiate_info_rsp *neg_rsp)
> +					 struct validate_negotiate_info_rsp *neg_rsp,
> +					 unsigned int in_buf_len)
>  {
>  	int ret =3D 0;
>  	int dialect;
>
> +	if (in_buf_len < sizeof(struct validate_negotiate_info_req) +
> +			le16_to_cpu(neg_req->DialectCount) * sizeof(__le16))
> +		return -EINVAL;
> +
>  	dialect =3D ksmbd_lookup_dialect_by_id(neg_req->Dialects,
>  					     neg_req->DialectCount);
>  	if (dialect =3D=3D BAD_PROT_ID || dialect !=3D conn->dialect) {
> @@ -7316,7 +7328,7 @@ static int fsctl_validate_negotiate_info(struct
> ksmbd_conn *conn,
>  static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
>  					struct file_allocated_range_buffer *qar_req,
>  					struct file_allocated_range_buffer *qar_rsp,
> -					int in_count, int *out_count)
> +					unsigned int in_count, unsigned int *out_count)
>  {
>  	struct ksmbd_file *fp;
>  	loff_t start, length;
> @@ -7343,7 +7355,8 @@ static int fsctl_query_allocated_ranges(struct
> ksmbd_work *work, u64 id,
>  }
>
>  static int fsctl_pipe_transceive(struct ksmbd_work *work, u64 id,
> -				 int out_buf_len, struct smb2_ioctl_req *req,
> +				 unsigned int out_buf_len,
> +				 struct smb2_ioctl_req *req,
>  				 struct smb2_ioctl_rsp *rsp)
>  {
>  	struct ksmbd_rpc_command *rpc_resp;
> @@ -7457,8 +7470,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>  {
>  	struct smb2_ioctl_req *req;
>  	struct smb2_ioctl_rsp *rsp, *rsp_org;
> -	int cnt_code, nbytes =3D 0;
> -	int out_buf_len;
> +	unsigned int cnt_code, nbytes =3D 0, out_buf_len, in_buf_len;
>  	u64 id =3D KSMBD_NO_FID;
>  	struct ksmbd_conn *conn =3D work->conn;
>  	int ret =3D 0;
> @@ -7487,7 +7499,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>
>  	cnt_code =3D le32_to_cpu(req->CntCode);
>  	out_buf_len =3D le32_to_cpu(req->MaxOutputResponse);
> -	out_buf_len =3D min(KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
> +	out_buf_len =3D
> +		min_t(u32, work->response_sz - work->next_smb2_rsp_hdr_off -
> +				(offsetof(struct smb2_ioctl_rsp, Buffer) - 4),
> +		      out_buf_len);
> +	in_buf_len =3D le32_to_cpu(req->InputCount);
>
>  	switch (cnt_code) {
>  	case FSCTL_DFS_GET_REFERRALS:
> @@ -7515,6 +7531,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>  		break;
>  	}
>  	case FSCTL_PIPE_TRANSCEIVE:
> +		out_buf_len =3D min_t(u32, KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
>  		nbytes =3D fsctl_pipe_transceive(work, id, out_buf_len, req, rsp);
>  		break;
>  	case FSCTL_VALIDATE_NEGOTIATE_INFO:
> @@ -7523,9 +7540,16 @@ int smb2_ioctl(struct ksmbd_work *work)
>  			goto out;
>  		}
>
> +		if (in_buf_len < sizeof(struct validate_negotiate_info_req))
> +			return -EINVAL;
> +
> +		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp))
> +			return -EINVAL;
> +
>  		ret =3D fsctl_validate_negotiate_info(conn,
>  			(struct validate_negotiate_info_req *)&req->Buffer[0],
> -			(struct validate_negotiate_info_rsp *)&rsp->Buffer[0]);
> +			(struct validate_negotiate_info_rsp *)&rsp->Buffer[0],
> +			in_buf_len);
>  		if (ret < 0)
>  			goto out;
>
> @@ -7534,7 +7558,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>  		rsp->VolatileFileId =3D cpu_to_le64(SMB2_NO_FID);
>  		break;
>  	case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
> -		nbytes =3D fsctl_query_iface_info_ioctl(conn, req, rsp);
> +		nbytes =3D fsctl_query_iface_info_ioctl(conn, rsp, out_buf_len);
>  		if (nbytes < 0)
>  			goto out;
>  		break;
> @@ -7561,15 +7585,33 @@ int smb2_ioctl(struct ksmbd_work *work)
>  			goto out;
>  		}
>
> +		if (in_buf_len < sizeof(struct copychunk_ioctl_req)) {
> +			ret =3D -EINVAL;
> +			goto out;
> +		}
> +
>  		if (out_buf_len < sizeof(struct copychunk_ioctl_rsp)) {
>  			ret =3D -EINVAL;
>  			goto out;
>  		}
>
>  		nbytes =3D sizeof(struct copychunk_ioctl_rsp);
> -		fsctl_copychunk(work, req, rsp);
> +		rsp->VolatileFileId =3D req->VolatileFileId;
> +		rsp->PersistentFileId =3D req->PersistentFileId;
> +		fsctl_copychunk(work,
> +				(struct copychunk_ioctl_req *)&req->Buffer[0],
> +				le32_to_cpu(req->CntCode),
> +				le32_to_cpu(req->InputCount),
> +				le64_to_cpu(req->VolatileFileId),
> +				le64_to_cpu(req->PersistentFileId),
> +				rsp);
>  		break;
>  	case FSCTL_SET_SPARSE:
> +		if (in_buf_len < sizeof(struct file_sparse)) {
> +			ret =3D -EINVAL;
> +			goto out;
> +		}
> +
>  		ret =3D fsctl_set_sparse(work, id,
>  				       (struct file_sparse *)&req->Buffer[0]);
>  		if (ret < 0)
> @@ -7588,6 +7630,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>  			goto out;
>  		}
>
> +		if (in_buf_len < sizeof(struct file_zero_data_information)) {
> +			ret =3D -EINVAL;
> +			goto out;
> +		}
> +
>  		zero_data =3D
>  			(struct file_zero_data_information *)&req->Buffer[0];
>
> @@ -7607,6 +7654,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>  		break;
>  	}
>  	case FSCTL_QUERY_ALLOCATED_RANGES:
> +		if (in_buf_len < sizeof(struct file_allocated_range_buffer)) {
> +			ret =3D -EINVAL;
> +			goto out;
> +		}
> +
>  		ret =3D fsctl_query_allocated_ranges(work, id,
>  			(struct file_allocated_range_buffer *)&req->Buffer[0],
>  			(struct file_allocated_range_buffer *)&rsp->Buffer[0],
> @@ -7647,6 +7699,11 @@ int smb2_ioctl(struct ksmbd_work *work)
>  		struct duplicate_extents_to_file *dup_ext;
>  		loff_t src_off, dst_off, length, cloned;
>
> +		if (in_buf_len < sizeof(struct duplicate_extents_to_file)) {
> +			ret =3D -EINVAL;
> +			goto out;
> +		}
> +
>  		dup_ext =3D (struct duplicate_extents_to_file *)&req->Buffer[0];
>
>  		fp_in =3D ksmbd_lookup_fd_slow(work, dup_ext->VolatileFileHandle,
> diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
> index b41954294d38..835b384b0895 100644
> --- a/fs/ksmbd/vfs.c
> +++ b/fs/ksmbd/vfs.c
> @@ -1023,7 +1023,7 @@ int ksmbd_vfs_zero_data(struct ksmbd_work *work,
> struct ksmbd_file *fp,
>
>  int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t
> length,
>  			 struct file_allocated_range_buffer *ranges,
> -			 int in_count, int *out_count)
> +			 unsigned int in_count, unsigned int *out_count)
>  {
>  	struct file *f =3D fp->filp;
>  	struct inode *inode =3D file_inode(fp->filp);
> diff --git a/fs/ksmbd/vfs.h b/fs/ksmbd/vfs.h
> index 7b1dcaa3fbdc..b0d5b8feb4a3 100644
> --- a/fs/ksmbd/vfs.h
> +++ b/fs/ksmbd/vfs.h
> @@ -166,7 +166,7 @@ int ksmbd_vfs_zero_data(struct ksmbd_work *work, stru=
ct
> ksmbd_file *fp,
>  struct file_allocated_range_buffer;
>  int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t
> length,
>  			 struct file_allocated_range_buffer *ranges,
> -			 int in_count, int *out_count);
> +			 unsigned int in_count, unsigned int *out_count);
>  int ksmbd_vfs_unlink(struct user_namespace *user_ns,
>  		     struct dentry *dir, struct dentry *dentry);
>  void *ksmbd_vfs_init_kstat(char **p, struct ksmbd_kstat *ksmbd_kstat);
> --
> 2.31.1
>
>
