Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE4E8C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 12:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DA8464F6E
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 12:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhCRMoz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Mar 2021 08:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231327AbhCRMoh (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 18 Mar 2021 08:44:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD1FD64F69
        for <linux-cifs@vger.kernel.org>; Thu, 18 Mar 2021 12:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616071477;
        bh=OXw5bJFvJyo7z5m7I4CfSgJncDinueliMHRln6QNUQI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=B9RaSgjCGIMMxuYCvx66P8k0O7JEbfRVMwlXV1yiyTeeu/O9g3AuasoPXxFBuPW5+
         rQe+SRLM4wciUKvfOy9hLSlGdSHnXb15VQimgg0Y22df3HG0eCRObOFdzaXktx560Q
         AIjO5mkzWBKwlfFe3yXIDkebCTl6IeRVHc7V+Hexb/D3tJtTLQG9+zqwPT/3NuBbdW
         sUb3gXZoFTHDoct6hBW6FDZ6PmpMeD15Ryb7L5zmJX36hD7Rw9nuQI1d73fc9S3oN+
         X1wLXvJ902qkT7ZD234rskrYQoUK3ev2rR/rAK8CeYEy4tlya+Z0yfihQrLBown6xf
         sOu6/e8FuCwAA==
Received: by mail-oi1-f177.google.com with SMTP id k25so1090890oic.4
        for <linux-cifs@vger.kernel.org>; Thu, 18 Mar 2021 05:44:36 -0700 (PDT)
X-Gm-Message-State: AOAM532ja914rf4LJOPMW3Z+70u/aLi+Fxb0IwzySdXGRS7JM0v3NPDW
        tdnV5bPP+9Nk5H1CfYQyxOLs86SQA1tckeIMLzc=
X-Google-Smtp-Source: ABdhPJx28xu7BUjS6TMVQM4Va1WkWKiEqboX3IgHfzWnmuVCCnpRkweQLYrlnHL1DzlWQ+oxoKIpEM6NjMX0RW/D9PI=
X-Received: by 2002:a05:6808:f12:: with SMTP id m18mr2726226oiw.62.1616071476039;
 Thu, 18 Mar 2021 05:44:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:4793:0:0:0:0:0 with HTTP; Thu, 18 Mar 2021 05:44:35
 -0700 (PDT)
In-Reply-To: <YFM/RCfCojoRxvsy@mwanda>
References: <YFM/RCfCojoRxvsy@mwanda>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 18 Mar 2021 21:44:35 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_+W8TFNjpr8Y66DoAwtHbTWdwgewianp3zM6x3pjULVg@mail.gmail.com>
Message-ID: <CAKYAXd_+W8TFNjpr8Y66DoAwtHbTWdwgewianp3zM6x3pjULVg@mail.gmail.com>
Subject: Re: [bug report] cifsd: make xattr format of ksmbd compatible with
 samba's one
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     namjae.jeon@samsung.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-03-18 20:53 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> Hello Namjae Jeon,
Hi Dan,

First, Thanks so much for your detailed explanation.
I will fix them and apply the patch included your reported-by tag tomorrow.
If you find any other issues, Let me know it:)

Thanks!
>
> The patch affbd69c2cb5: "cifsd: make xattr format of ksmbd compatible
> with samba's one" from Jan 28, 2021, leads to the following static
> checker warning:
>
> 	fs/cifsd/smbacl.c:1140 smb_check_perm_dacl()
> 	error: we previously assumed 'pntsd' could be null (see line 1137)
>
> fs/cifsd/smbacl.c
>   1119  int smb_check_perm_dacl(struct ksmbd_conn *conn, struct dentry
> *dentry,
>   1120                  __le32 *pdaccess, int uid)
>   1121  {
>   1122          struct smb_ntsd *pntsd = NULL;
>   1123          struct smb_acl *pdacl;
>   1124          struct posix_acl *posix_acls;
>   1125          int rc = 0, acl_size;
>   1126          struct smb_sid sid;
>   1127          int granted = le32_to_cpu(*pdaccess &
> ~FILE_MAXIMAL_ACCESS_LE);
>   1128          struct smb_ace *ace;
>   1129          int i, found = 0;
>   1130          unsigned int access_bits = 0;
>   1131          struct smb_ace *others_ace = NULL;
>   1132          struct posix_acl_entry *pa_entry;
>   1133          unsigned int sid_type = SIDOWNER;
>   1134
>   1135          ksmbd_debug(SMB, "check permission using windows acl\n");
>   1136          acl_size = ksmbd_vfs_get_sd_xattr(conn, dentry, &pntsd);
>   1137          if (acl_size <= 0 || (pntsd && !pntsd->dacloffset))
>                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Presumably this should be "if (acl_size <= 0 || !pntsd)
> 				return 0;
>
> If pntsd is NULL then we are toasted.
>
>   1138                  return 0;
>   1139
>   1140          pdacl = (struct smb_acl *)((char *)pntsd +
> le32_to_cpu(pntsd->dacloffset));
>
> But as I look at this warning, I am much more concerned that we are
> trusting pntsd->dacloffset at all.  It doesn't appear that we have
> bounds checked the upper limit.
>
> Unrelated and minor:  The ndr_read_bytes() function has the src, dest
> parameters reversed which is going to chaos and confusion and in the
> future.  ;)
>
>   1141          if (!pdacl->num_aces) {
>   1142                  if (!(le16_to_cpu(pdacl->size) - sizeof(struct
> smb_acl)) &&
>   1143                      *pdaccess & ~(FILE_READ_CONTROL_LE |
> FILE_WRITE_DAC_LE)) {
>   1144                          rc = -EACCES;
>   1145                          goto err_out;
>   1146                  }
>   1147                  kfree(pntsd);
>   1148                  return 0;
>   1149          }
>
> There is another similar sort of static checker warning:
>
> fs/cifsd/smbacl.c:803 parse_sec_desc() warn: 'dacl_ptr' can't be NULL
>    778  int parse_sec_desc(struct smb_ntsd *pntsd, int acl_len,
>    779                  struct smb_fattr *fattr)
>    780  {
>    781          int rc = 0;
>    782          struct smb_sid *owner_sid_ptr, *group_sid_ptr;
>    783          struct smb_acl *dacl_ptr; /* no need for SACL ptr */
>    784          char *end_of_acl = ((char *)pntsd) + acl_len;
>    785          __u32 dacloffset;
>    786          int total_ace_size = 0, pntsd_type;
>    787
>    788          if (pntsd == NULL)
>    789                  return -EIO;
>    790
>    791          owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
>    792                          le32_to_cpu(pntsd->osidoffset));
>    793          group_sid_ptr = (struct smb_sid *)((char *)pntsd +
>    794                          le32_to_cpu(pntsd->gsidoffset));
>    795          dacloffset = le32_to_cpu(pntsd->dacloffset);
>    796          dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
>                                                       ^^^^^
> pntsd is non-NULL so dacl_ptr can't be NULL.  We're trusting a lot of
> these offsets to be non-malicious.
>
>    797          ksmbd_debug(SMB,
>    798                  "revision %d type 0x%x ooffset 0x%x goffset 0x%x
> sacloffset 0x%x dacloffset 0x%x\n",
>    799                   pntsd->revision, pntsd->type,
> le32_to_cpu(pntsd->osidoffset),
>    800                   le32_to_cpu(pntsd->gsidoffset),
>    801                   le32_to_cpu(pntsd->sacloffset), dacloffset);
>    802
>    803          if (dacloffset && dacl_ptr)
>    804                  total_ace_size =
>    805                          le16_to_cpu(dacl_ptr->size) - sizeof(struct
> smb_acl);
>    806
>    807          pntsd_type = le16_to_cpu(pntsd->type);
>    808
>
> regards,
> dan carpenter
>
