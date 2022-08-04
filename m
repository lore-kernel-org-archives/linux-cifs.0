Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9492DC25B06
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Aug 2022 23:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbiHDXDL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Aug 2022 19:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234270AbiHDXDK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Aug 2022 19:03:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7DA3F314
        for <linux-cifs@vger.kernel.org>; Thu,  4 Aug 2022 16:03:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9EF8B8278D
        for <linux-cifs@vger.kernel.org>; Thu,  4 Aug 2022 23:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BE0C433B5
        for <linux-cifs@vger.kernel.org>; Thu,  4 Aug 2022 23:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659654186;
        bh=/ygXX5z/5aMwSXmphaeUPpy0z6UALEEccWCxUauQQT8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=WVLx0Lmr4WM8rgN8tgJRBrNwS2ggBGS/qZ0FRZJGjVBEifJkVvnp2JHiV56erITNU
         YzihSJS0L2E94RPYoWlU0pA3TnJ+FlxMlisSnAremNoxCzdCtj41MthVZdZ5ANSC2o
         Ge4HtMiQ8MzJKSKvh5y4IbM4K4YFHoM0Wr1/JvZDRxxHgmtA/1XtO3g9Au/PbHColu
         IcG9ojm7FRDXXRDU3RWFPb5AQo2iSoN1X4iX2VpgToY3V1wRUjcm2I6rilTTTAdT5Z
         wxpMaOfeV1+Src9W5x9avuC4PAtFX2ZGZvsm2yIw9gefCzOvLDwhJV1xoCqtG0l2vG
         iJdOuTu1qrk+w==
Received: by mail-oi1-f181.google.com with SMTP id n133so1066528oib.0
        for <linux-cifs@vger.kernel.org>; Thu, 04 Aug 2022 16:03:06 -0700 (PDT)
X-Gm-Message-State: ACgBeo0dtrArN+2vM7geMGP3CEbfMVCsRv71el9EWb7aFamk9uC4t5YI
        M87NpqNHj+pNyWigEW/fL05CsV1+70fkpoOmrcg=
X-Google-Smtp-Source: AA6agR5Wu0+6MH0bGhwyaWrnPW3kpVGnvkU5SiY9eljGKWAMF4muoJW//sdZ/jV+7q5yEvpWb80Qz/t/4WbcXahu4SE=
X-Received: by 2002:a05:6808:13c5:b0:33a:ff74:bf11 with SMTP id
 d5-20020a05680813c500b0033aff74bf11mr1905239oiw.257.1659654185718; Thu, 04
 Aug 2022 16:03:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6839:41a4:0:0:0:0 with HTTP; Thu, 4 Aug 2022 16:03:04
 -0700 (PDT)
In-Reply-To: <YuvYoM5nknSDxJFj@kili>
References: <YuvYoM5nknSDxJFj@kili>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 5 Aug 2022 08:03:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9PDUBLvoZqS26mMKqdS6J1b-MQ6LNgy=W7POjXu_+L4Q@mail.gmail.com>
Message-ID: <CAKYAXd9PDUBLvoZqS26mMKqdS6J1b-MQ6LNgy=W7POjXu_+L4Q@mail.gmail.com>
Subject: Re: [bug report] ksmbd: fix heap-based overflow in set_ntacl_dacl()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-04 23:33 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> Hello Namjae Jeon,
Hi Dan,
>
> The patch 982979772f2b: "ksmbd: fix heap-based overflow in
> set_ntacl_dacl()" from Jul 28, 2022, leads to the following Smatch
> static checker warning:
>
> 	fs/ksmbd/smb2pdu.c:5182 smb2_get_info_sec()
> 	error: uninitialized symbol 'secdesclen'.
This was fixed on v4 patch :
  https://marc.info/?l=linux-cifs&m=165939383203779&w=2

Thanks for your report!
>
> fs/ksmbd/smb2pdu.c
>     5109 static int smb2_get_info_sec(struct ksmbd_work *work,
>     5110                              struct smb2_query_info_req *req,
>     5111                              struct smb2_query_info_rsp *rsp)
>     5112 {
>     5113         struct ksmbd_file *fp;
>     5114         struct user_namespace *user_ns;
>     5115         struct smb_ntsd *pntsd = (struct smb_ntsd *)rsp->Buffer,
> *ppntsd = NULL;
>     5116         struct smb_fattr fattr = {{0}};
>     5117         struct inode *inode;
>     5118         __u32 secdesclen;
>     5119         unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
>     5120         int addition_info =
> le32_to_cpu(req->AdditionalInformation);
>     5121         int rc = 0, ppntsd_size = 0;
>     5122
>     5123         if (addition_info & ~(OWNER_SECINFO | GROUP_SECINFO |
> DACL_SECINFO |
>     5124                               PROTECTED_DACL_SECINFO |
>     5125                               UNPROTECTED_DACL_SECINFO)) {
>     5126                 ksmbd_debug(SMB, "Unsupported addition info:
> 0x%x)\n",
>     5127                        addition_info);
>     5128
>     5129                 pntsd->revision = cpu_to_le16(1);
>     5130                 pntsd->type = cpu_to_le16(SELF_RELATIVE |
> DACL_PROTECTED);
>     5131                 pntsd->osidoffset = 0;
>     5132                 pntsd->gsidoffset = 0;
>     5133                 pntsd->sacloffset = 0;
>     5134                 pntsd->dacloffset = 0;
>     5135
>     5136                 secdesclen = sizeof(struct smb_ntsd);
>     5137                 rsp->OutputBufferLength = cpu_to_le32(secdesclen);
>     5138                 inc_rfc1001_len(work->response_buf, secdesclen);
>     5139
>     5140                 return 0;
>     5141         }
>     5142
>     5143         if (work->next_smb2_rcv_hdr_off) {
>     5144                 if (!has_file_id(req->VolatileFileId)) {
>     5145                         ksmbd_debug(SMB, "Compound request set FID
> = %llu\n",
>     5146                                     work->compound_fid);
>     5147                         id = work->compound_fid;
>     5148                         pid = work->compound_pfid;
>     5149                 }
>     5150         }
>     5151
>     5152         if (!has_file_id(id)) {
>     5153                 id = req->VolatileFileId;
>     5154                 pid = req->PersistentFileId;
>     5155         }
>     5156
>     5157         fp = ksmbd_lookup_fd_slow(work, id, pid);
>     5158         if (!fp)
>     5159                 return -ENOENT;
>     5160
>     5161         user_ns = file_mnt_user_ns(fp->filp);
>     5162         inode = file_inode(fp->filp);
>     5163         ksmbd_acls_fattr(&fattr, user_ns, inode);
>     5164
>     5165         if (test_share_config_flag(work->tcon->share_conf,
>     5166                                    KSMBD_SHARE_FLAG_ACL_XATTR))
>     5167                 ppntsd_size = ksmbd_vfs_get_sd_xattr(work->conn,
> user_ns,
>     5168
> fp->filp->f_path.dentry,
>     5169                                                      &ppntsd);
>     5170
>     5171         /* Check if sd buffer size exceeds response buffer size */
>     5172         if (smb2_resp_buf_len(work, 8) > ppntsd_size)
>     5173                 rc = build_sec_desc(user_ns, pntsd, ppntsd,
> ppntsd_size,
>     5174                                     addition_info, &secdesclen,
> &fattr);
>
> "secdesclen" is not initialized on else path.
>
>     5175         posix_acl_release(fattr.cf_acls);
>     5176         posix_acl_release(fattr.cf_dacls);
>     5177         kfree(ppntsd);
>     5178         ksmbd_fd_put(work, fp);
>     5179         if (rc)
>     5180                 return rc;
>     5181
> --> 5182         rsp->OutputBufferLength = cpu_to_le32(secdesclen);
>     5183         inc_rfc1001_len(work->response_buf, secdesclen);
>     5184         return 0;
>     5185 }
>
> regards,
> dan carpenter
>
