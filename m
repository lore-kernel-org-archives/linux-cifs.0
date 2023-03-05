Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46494C61DA4
	for <linux-cifs@archiver.kernel.org>; Sun,  5 Mar 2023 12:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjCEMgQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 5 Mar 2023 07:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjCEMgP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 5 Mar 2023 07:36:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FEEEB74
        for <linux-cifs@vger.kernel.org>; Sun,  5 Mar 2023 04:36:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D7C960AC9
        for <linux-cifs@vger.kernel.org>; Sun,  5 Mar 2023 12:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76FAC433D2
        for <linux-cifs@vger.kernel.org>; Sun,  5 Mar 2023 12:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678019772;
        bh=T36Q62YkSYpASUJvP4Qm2J/yGaGdFR47qY1LsGOFtZk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=bRcYSRlv3HrEiv9JPfL7hScwXN3UFJSn7h5rhFLFz79ykY3MqMciGBOyPFpyGpagh
         1eM2dYVvnih3d8Trk8orfuEH99Q18eQmdQJxeLqSm+Mw87ptUyxZjtaujDFYcM4iz8
         YTHecdVsZeK/ngrYj/aTlLG3uMl8u32D1QEn5vObCEl0rd1vGF/TTXYelh615fMYuh
         Gc850Bdhz9lyqI97zVuZ4JYpGp6xhg4T+BGptGorFYqMGckmj7GYv2Utk40lJS0LWI
         YsWddyBq8bxE9PY61cAjDI8RQikp/58pfwjT2lM+mbqOXOHtMV/faQpeV3JXRtYO+p
         QE0aj5Z3kNBaw==
Received: by mail-oi1-f174.google.com with SMTP id bh20so5108879oib.9
        for <linux-cifs@vger.kernel.org>; Sun, 05 Mar 2023 04:36:12 -0800 (PST)
X-Gm-Message-State: AO0yUKW5YG/4Q7YINFcCejxKEOXNw/rH4Pnrz2A0WfnLCwtfqsSqop7h
        nNp1JG3LZMl9lCTvov/hCjTEqZN1Ui1+gKbF12E=
X-Google-Smtp-Source: AK7set8cvpwx0swmeQMyOUxbU5jaXju4haHgA0luS4rX4qGe8DWRXB0k6yl7XXXgYDFJXxjlbNSG9n9nUZpuKtQF8Q8=
X-Received: by 2002:aca:650b:0:b0:383:c3d5:6c9f with SMTP id
 m11-20020aca650b000000b00383c3d56c9fmr2354651oim.11.1678019772053; Sun, 05
 Mar 2023 04:36:12 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:67ca:0:b0:4c2:5d59:8c51 with HTTP; Sun, 5 Mar 2023
 04:36:11 -0800 (PST)
In-Reply-To: <b3d7e152-07f2-4e54-9c8a-3ed13b750e0f@kili.mountain>
References: <b3d7e152-07f2-4e54-9c8a-3ed13b750e0f@kili.mountain>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 5 Mar 2023 21:36:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9=pjEegDXDRQ=7LjXdP-t==z_Do=Mm+RZxwm3+4A_SWA@mail.gmail.com>
Message-ID: <CAKYAXd9=pjEegDXDRQ=7LjXdP-t==z_Do=Mm+RZxwm3+4A_SWA@mail.gmail.com>
Subject: Re: [bug report] ksmbd: check invalid FileOffset and BeyondFinalZero
 in FSCTL_ZERO_DATA
To:     Dan Carpenter <error27@gmail.com>
Cc:     linux-cifs@vger.kernel.org, cip-dev <cip-dev@lists.cip-project.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-03-03 23:12 GMT+09:00, Dan Carpenter <error27@gmail.com>:
> Hello Namjae Jeon,
Hello Dan,

I have sent the patch for this to the list.

Thanks for your report!
>
> The patch b5e5f9dfc915: "ksmbd: check invalid FileOffset and
> BeyondFinalZero in FSCTL_ZERO_DATA" from Jun 19, 2022, leads to the
> following Smatch static checker warning:
>
> 	fs/ksmbd/smb2pdu.c:7759 smb2_ioctl()
> 	warn: no lower bound on 'off'
>
> fs/ksmbd/smb2pdu.c
>     7573 int smb2_ioctl(struct ksmbd_work *work)
>     7574 {
>     7575         struct smb2_ioctl_req *req;
>     7576         struct smb2_ioctl_rsp *rsp;
>     7577         unsigned int cnt_code, nbytes = 0, out_buf_len,
> in_buf_len;
>     7578         u64 id = KSMBD_NO_FID;
>     7579         struct ksmbd_conn *conn = work->conn;
>     7580         int ret = 0;
>     7581
>     7582         if (work->next_smb2_rcv_hdr_off) {
>     7583                 req = ksmbd_req_buf_next(work);
>     7584                 rsp = ksmbd_resp_buf_next(work);
>     7585                 if (!has_file_id(req->VolatileFileId)) {
>     7586                         ksmbd_debug(SMB, "Compound request set FID
> = %llu\n",
>     7587                                     work->compound_fid);
>     7588                         id = work->compound_fid;
>     7589                 }
>     7590         } else {
>     7591                 req = smb2_get_msg(work->request_buf);
>     7592                 rsp = smb2_get_msg(work->response_buf);
>     7593         }
>     7594
>     7595         if (!has_file_id(id))
>     7596                 id = req->VolatileFileId;
>     7597
>     7598         if (req->Flags != cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL)) {
>     7599                 rsp->hdr.Status = STATUS_NOT_SUPPORTED;
>     7600                 goto out;
>     7601         }
>     7602
>     7603         cnt_code = le32_to_cpu(req->CtlCode);
>     7604         ret = smb2_calc_max_out_buf_len(work, 48,
>     7605
> le32_to_cpu(req->MaxOutputResponse));
>     7606         if (ret < 0) {
>     7607                 rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>     7608                 goto out;
>     7609         }
>     7610         out_buf_len = (unsigned int)ret;
>     7611         in_buf_len = le32_to_cpu(req->InputCount);
>     7612
>     7613         switch (cnt_code) {
>     7614         case FSCTL_DFS_GET_REFERRALS:
>     7615         case FSCTL_DFS_GET_REFERRALS_EX:
>     7616                 /* Not support DFS yet */
>     7617                 rsp->hdr.Status = STATUS_FS_DRIVER_REQUIRED;
>     7618                 goto out;
>     7619         case FSCTL_CREATE_OR_GET_OBJECT_ID:
>     7620         {
>     7621                 struct file_object_buf_type1_ioctl_rsp *obj_buf;
>     7622
>     7623                 nbytes = sizeof(struct
> file_object_buf_type1_ioctl_rsp);
>     7624                 obj_buf = (struct file_object_buf_type1_ioctl_rsp
> *)
>     7625                         &rsp->Buffer[0];
>     7626
>     7627                 /*
>     7628                  * TODO: This is dummy implementation to pass
> smbtorture
>     7629                  * Need to check correct response later
>     7630                  */
>     7631                 memset(obj_buf->ObjectId, 0x0, 16);
>     7632                 memset(obj_buf->BirthVolumeId, 0x0, 16);
>     7633                 memset(obj_buf->BirthObjectId, 0x0, 16);
>     7634                 memset(obj_buf->DomainId, 0x0, 16);
>     7635
>     7636                 break;
>     7637         }
>     7638         case FSCTL_PIPE_TRANSCEIVE:
>     7639                 out_buf_len = min_t(u32, KSMBD_IPC_MAX_PAYLOAD,
> out_buf_len);
>     7640                 nbytes = fsctl_pipe_transceive(work, id,
> out_buf_len, req, rsp);
>     7641                 break;
>     7642         case FSCTL_VALIDATE_NEGOTIATE_INFO:
>     7643                 if (conn->dialect < SMB30_PROT_ID) {
>     7644                         ret = -EOPNOTSUPP;
>     7645                         goto out;
>     7646                 }
>     7647
>     7648                 if (in_buf_len < offsetof(struct
> validate_negotiate_info_req,
>     7649                                           Dialects)) {
>     7650                         ret = -EINVAL;
>     7651                         goto out;
>     7652                 }
>     7653
>     7654                 if (out_buf_len < sizeof(struct
> validate_negotiate_info_rsp)) {
>     7655                         ret = -EINVAL;
>     7656                         goto out;
>     7657                 }
>     7658
>     7659                 ret = fsctl_validate_negotiate_info(conn,
>     7660                         (struct validate_negotiate_info_req
> *)&req->Buffer[0],
>     7661                         (struct validate_negotiate_info_rsp
> *)&rsp->Buffer[0],
>     7662                         in_buf_len);
>     7663                 if (ret < 0)
>     7664                         goto out;
>     7665
>     7666                 nbytes = sizeof(struct
> validate_negotiate_info_rsp);
>     7667                 rsp->PersistentFileId = SMB2_NO_FID;
>     7668                 rsp->VolatileFileId = SMB2_NO_FID;
>     7669                 break;
>     7670         case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
>     7671                 ret = fsctl_query_iface_info_ioctl(conn, rsp,
> out_buf_len);
>     7672                 if (ret < 0)
>     7673                         goto out;
>     7674                 nbytes = ret;
>     7675                 break;
>     7676         case FSCTL_REQUEST_RESUME_KEY:
>     7677                 if (out_buf_len < sizeof(struct
> resume_key_ioctl_rsp)) {
>     7678                         ret = -EINVAL;
>     7679                         goto out;
>     7680                 }
>     7681
>     7682                 ret = fsctl_request_resume_key(work, req,
>     7683                                                (struct
> resume_key_ioctl_rsp *)&rsp->Buffer[0]);
>     7684                 if (ret < 0)
>     7685                         goto out;
>     7686                 rsp->PersistentFileId = req->PersistentFileId;
>     7687                 rsp->VolatileFileId = req->VolatileFileId;
>     7688                 nbytes = sizeof(struct resume_key_ioctl_rsp);
>     7689                 break;
>     7690         case FSCTL_COPYCHUNK:
>     7691         case FSCTL_COPYCHUNK_WRITE:
>     7692                 if (!test_tree_conn_flag(work->tcon,
> KSMBD_TREE_CONN_FLAG_WRITABLE)) {
>     7693                         ksmbd_debug(SMB,
>     7694                                     "User does not have write
> permission\n");
>     7695                         ret = -EACCES;
>     7696                         goto out;
>     7697                 }
>     7698
>     7699                 if (in_buf_len < sizeof(struct
> copychunk_ioctl_req)) {
>     7700                         ret = -EINVAL;
>     7701                         goto out;
>     7702                 }
>     7703
>     7704                 if (out_buf_len < sizeof(struct
> copychunk_ioctl_rsp)) {
>     7705                         ret = -EINVAL;
>     7706                         goto out;
>     7707                 }
>     7708
>     7709                 nbytes = sizeof(struct copychunk_ioctl_rsp);
>     7710                 rsp->VolatileFileId = req->VolatileFileId;
>     7711                 rsp->PersistentFileId = req->PersistentFileId;
>     7712                 fsctl_copychunk(work,
>     7713                                 (struct copychunk_ioctl_req
> *)&req->Buffer[0],
>     7714                                 le32_to_cpu(req->CtlCode),
>     7715                                 le32_to_cpu(req->InputCount),
>     7716                                 req->VolatileFileId,
>     7717                                 req->PersistentFileId,
>     7718                                 rsp);
>     7719                 break;
>     7720         case FSCTL_SET_SPARSE:
>     7721                 if (in_buf_len < sizeof(struct file_sparse)) {
>     7722                         ret = -EINVAL;
>     7723                         goto out;
>     7724                 }
>     7725
>     7726                 ret = fsctl_set_sparse(work, id,
>     7727                                        (struct file_sparse
> *)&req->Buffer[0]);
>     7728                 if (ret < 0)
>     7729                         goto out;
>     7730                 break;
>     7731         case FSCTL_SET_ZERO_DATA:
>     7732         {
>     7733                 struct file_zero_data_information *zero_data;
>     7734                 struct ksmbd_file *fp;
>     7735                 loff_t off, len, bfz;
>     7736
>     7737                 if (!test_tree_conn_flag(work->tcon,
> KSMBD_TREE_CONN_FLAG_WRITABLE)) {
>     7738                         ksmbd_debug(SMB,
>     7739                                     "User does not have write
> permission\n");
>     7740                         ret = -EACCES;
>     7741                         goto out;
>     7742                 }
>     7743
>     7744                 if (in_buf_len < sizeof(struct
> file_zero_data_information)) {
>     7745                         ret = -EINVAL;
>     7746                         goto out;
>     7747                 }
>     7748
>     7749                 zero_data =
>     7750                         (struct file_zero_data_information
> *)&req->Buffer[0];
>     7751
>     7752                 off = le64_to_cpu(zero_data->FileOffset);
>     7753                 bfz = le64_to_cpu(zero_data->BeyondFinalZero);
>     7754                 if (off > bfz) {
>
> Should we check for negative values of "off"?  To be honest,
> Smatch doesn't really trust either off or bfz...
>
>     7755                         ret = -EINVAL;
>     7756                         goto out;
>     7757                 }
>     7758
> --> 7759                 len = bfz - off;
>     7760                 if (len) {
>     7761                         fp = ksmbd_lookup_fd_fast(work, id);
>     7762                         if (!fp) {
>     7763                                 ret = -ENOENT;
>     7764                                 goto out;
>     7765                         }
>     7766
>     7767                         ret = ksmbd_vfs_zero_data(work, fp, off,
> len);
>     7768                         ksmbd_fd_put(work, fp);
>     7769                         if (ret < 0)
>     7770                                 goto out;
>     7771                 }
>     7772                 break;
>     7773         }
>
> regards,
> dan carpenter
>
