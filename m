Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD98C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 23:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiJQXMN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 19:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiJQXL6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 19:11:58 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DE5857FD
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 16:11:35 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id g27so18136322edf.11
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 16:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0sHX9EvPHhaX6Wid0i1wtyr+Z6iYV15Hik14CyaMabg=;
        b=e3+e85SaWpHspjf4nEZqRsa+003iZ/5wkBZD9D6TbHWCQht7szc90S+gS7dxsuDRAi
         afv5cJden3r5sMdPlrNs8Cn/3IGdYvSBVHtRCR8GVzwmAVvx980mqfdA2HNjr2eEkvuk
         tKeK39MLy4tt94oEI6RLTg/1lhGmWMhjv4fkLhhpfSQCXSrTFqfi1Z6G6BjrxykOUem9
         fJPalrVFbIpo0+jI84/1qVR07RigjTQg90slRfMT4yTWLcx+zILFhpWA7awr2kxQGiwO
         PCkNMTs4BkJ26OLxTlhzyJYKt2x8ee6XQAzgR8RHkae64BlNj5Cc8U6pVXlyoxGEe+ou
         qOPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0sHX9EvPHhaX6Wid0i1wtyr+Z6iYV15Hik14CyaMabg=;
        b=MNOvHSl90/LMw24rtK/vOi1zmrcuplIfFZY8UtTGS7yLt7eoYwJzLdjMN4rLwQIAoC
         JZDywvluKadbNJz63nv+xMBK9kautXcOM/F7qxjhQvaIZLYm/hkh1NEfkB7B6mYmppIi
         eeUjdbwc2opLlafL128Re6cL2ZRmj+HoHKD/lre65/opArU9m5abQugkbOty3DMCdwRd
         1d57Q+I/n8emyncZgEmPZeklnCKBFv+cJxMLWNz6Xfm+uvdsFEmeA3xK1U4Mitp9RvHb
         rGFFku8aUXUChcyzynkmwGUTOhuWIfRufYB4Gh2b+cB41Eqho53149B+02T4BaCBWrJS
         Rrsw==
X-Gm-Message-State: ACrzQf3d/hdQSk8pD00sfvL9bfrsK/PruP23I4x9nz8GMkR6r+CZmmAo
        YYLU+obxm6u3LMzl/BaijdiPdo/CkQociUk15cY=
X-Google-Smtp-Source: AMsMyM42X2UKrUvstK4cSQZA/YFBTYumSH6/Yab6xoG7a0p8BgLfDjaHtZ05Zh+yKxnf1qslHN2CAz5/Z+VtV6Ievas=
X-Received: by 2002:a05:6402:11ce:b0:45c:a2a2:4207 with SMTP id
 j14-20020a05640211ce00b0045ca2a24207mr56485edw.3.1666048248769; Mon, 17 Oct
 2022 16:10:48 -0700 (PDT)
MIME-Version: 1.0
References: <Y0l0ylvXH1kLbL0F@kili>
In-Reply-To: <Y0l0ylvXH1kLbL0F@kili>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 18 Oct 2022 09:10:36 +1000
Message-ID: <CAN05THRXCgWQhDBkGD4V=oW3dZBmhhEyHpW3P5cE87qCUKtr-w@mail.gmail.com>
Subject: Re: [bug report] cifs: find and use the dentry for cached non-root
 directories also
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     lsahlber@redhat.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Dan,

rc is set to -ENOENT somewhat later and this is what is returned to
the application for this case.
However, I will fix this so that we do not get a smash warning for it.

regards
Ronnie Sahlberg

On Sat, 15 Oct 2022 at 00:54, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hello Ronnie Sahlberg,
>
> The patch ab2ef9a696a6: "cifs: find and use the dentry for cached
> non-root directories also" from Oct 12, 2022, leads to the following
> Smatch static checker warning:
>
>         fs/cifs/cached_dir.c:257 open_cached_dir()
>         warn: missing error code here? 'IS_ERR()' failed. 'rc' = '0'
>
> fs/cifs/cached_dir.c
>     105 int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>     106                     const char *path,
>     107                     struct cifs_sb_info *cifs_sb,
>     108                     bool lookup_only, struct cached_fid **ret_cfid)
>     109 {
>     110         struct cifs_ses *ses;
>     111         struct TCP_Server_Info *server;
>     112         struct cifs_open_parms oparms;
>     113         struct smb2_create_rsp *o_rsp = NULL;
>     114         struct smb2_query_info_rsp *qi_rsp = NULL;
>     115         int resp_buftype[2];
>     116         struct smb_rqst rqst[2];
>     117         struct kvec rsp_iov[2];
>     118         struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
>     119         struct kvec qi_iov[1];
>     120         int rc, flags = 0;
>     121         __le16 *utf16_path = NULL;
>     122         u8 oplock = SMB2_OPLOCK_LEVEL_II;
>     123         struct cifs_fid *pfid;
>     124         struct dentry *dentry = NULL;
>     125         struct cached_fid *cfid;
>     126         struct cached_fids *cfids;
>     127
>     128         if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
>     129             is_smb1_server(tcon->ses->server))
>     130                 return -EOPNOTSUPP;
>     131
>     132         ses = tcon->ses;
>     133         server = ses->server;
>     134         cfids = tcon->cfids;
>     135
>     136         if (!server->ops->new_lease_key)
>     137                 return -EIO;
>     138
>     139         if (cifs_sb->root == NULL)
>     140                 return -ENOENT;
>     141
>     142         utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
>     143         if (!utf16_path)
>     144                 return -ENOMEM;
>     145
>     146         cfid = find_or_create_cached_dir(cfids, path, lookup_only);
>     147         if (cfid == NULL) {
>     148                 kfree(utf16_path);
>     149                 return -ENOENT;
>     150         }
>     151         /*
>     152          * At this point we either have a lease already and we can just
>     153          * return it. If not we are guaranteed to be the only thread accessing
>     154          * this cfid.
>     155          */
>     156         if (cfid->has_lease) {
>     157                 *ret_cfid = cfid;
>     158                 kfree(utf16_path);
>     159                 return 0;
>     160         }
>     161
>     162         /*
>     163          * We do not hold the lock for the open because in case
>     164          * SMB2_open needs to reconnect.
>     165          * This is safe because no other thread will be able to get a ref
>     166          * to the cfid until we have finished opening the file and (possibly)
>     167          * acquired a lease.
>     168          */
>     169         if (smb3_encryption_required(tcon))
>     170                 flags |= CIFS_TRANSFORM_REQ;
>     171
>     172         pfid = &cfid->fid;
>     173         server->ops->new_lease_key(pfid);
>     174
>     175         memset(rqst, 0, sizeof(rqst));
>     176         resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
>     177         memset(rsp_iov, 0, sizeof(rsp_iov));
>     178
>     179         /* Open */
>     180         memset(&open_iov, 0, sizeof(open_iov));
>     181         rqst[0].rq_iov = open_iov;
>     182         rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
>     183
>     184         oparms.tcon = tcon;
>     185         oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE);
>     186         oparms.desired_access = FILE_READ_ATTRIBUTES;
>     187         oparms.disposition = FILE_OPEN;
>     188         oparms.fid = pfid;
>     189         oparms.reconnect = false;
>     190
>     191         rc = SMB2_open_init(tcon, server,
>     192                             &rqst[0], &oplock, &oparms, utf16_path);
>     193         if (rc)
>     194                 goto oshr_free;
>     195         smb2_set_next_command(tcon, &rqst[0]);
>     196
>     197         memset(&qi_iov, 0, sizeof(qi_iov));
>     198         rqst[1].rq_iov = qi_iov;
>     199         rqst[1].rq_nvec = 1;
>     200
>     201         rc = SMB2_query_info_init(tcon, server,
>     202                                   &rqst[1], COMPOUND_FID,
>     203                                   COMPOUND_FID, FILE_ALL_INFORMATION,
>     204                                   SMB2_O_INFO_FILE, 0,
>     205                                   sizeof(struct smb2_file_all_info) +
>     206                                   PATH_MAX * 2, 0, NULL);
>     207         if (rc)
>     208                 goto oshr_free;
>     209
>     210         smb2_set_related(&rqst[1]);
>     211
>     212         rc = compound_send_recv(xid, ses, server,
>     213                                 flags, 2, rqst,
>     214                                 resp_buftype, rsp_iov);
>     215         if (rc) {
>     216                 if (rc == -EREMCHG) {
>     217                         tcon->need_reconnect = true;
>     218                         pr_warn_once("server share %s deleted\n",
>     219                                      tcon->tree_name);
>     220                 }
>     221                 goto oshr_free;
>     222         }
>     223
>     224         atomic_inc(&tcon->num_remote_opens);
>     225
>     226         o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
>     227         oparms.fid->persistent_fid = o_rsp->PersistentFileId;
>     228         oparms.fid->volatile_fid = o_rsp->VolatileFileId;
>     229 #ifdef CONFIG_CIFS_DEBUG2
>     230         oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
>     231 #endif /* CIFS_DEBUG2 */
>     232
>     233         if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE)
>     234                 goto oshr_free;
>     235
>     236
>     237         smb2_parse_contexts(server, o_rsp,
>     238                             &oparms.fid->epoch,
>     239                             oparms.fid->lease_key, &oplock,
>     240                             NULL, NULL);
>     241
>     242         qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
>     243         if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
>     244                 goto oshr_free;
>     245         if (!smb2_validate_and_copy_iov(
>     246                                 le16_to_cpu(qi_rsp->OutputBufferOffset),
>     247                                 sizeof(struct smb2_file_all_info),
>     248                                 &rsp_iov[1], sizeof(struct smb2_file_all_info),
>     249                                 (char *)&cfid->file_all_info))
>     250                 cfid->file_all_info_is_valid = true;
>     251
>     252         if (!path[0])
>     253                 dentry = dget(cifs_sb->root);
>     254         else {
>     255                 dentry = path_to_dentry(cifs_sb, path);
>     256                 if (IS_ERR(dentry))
> --> 257                         goto oshr_free;
>
> Should this be an error path?  There is a lot going on in the cleanup
> code so maybe the error code is set later.
>
>     258         }
>     259         cfid->dentry = dentry;
>     260         cfid->tcon = tcon;
>     261         cfid->time = jiffies;
>     262         cfid->is_open = true;
>     263         cfid->has_lease = true;
>     264
>     265 oshr_free:
>     266         kfree(utf16_path);
>     267         SMB2_open_free(&rqst[0]);
>     268         SMB2_query_info_free(&rqst[1]);
>     269         free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
>     270         free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
>     271         spin_lock(&cfids->cfid_list_lock);
>     272         if (!cfid->has_lease) {
>     273                 if (cfid->on_list) {
>     274                         list_del(&cfid->entry);
>     275                         cfid->on_list = false;
>     276                         cfids->num_entries--;
>     277                 }
>     278                 rc = -ENOENT;
>     279         }
>     280         spin_unlock(&cfids->cfid_list_lock);
>     281         if (rc) {
>     282                 free_cached_dir(cfid);
>     283                 cfid = NULL;
>     284         }
>     285
>     286         if (rc == 0)
>     287                 *ret_cfid = cfid;
>     288
>     289         return rc;
>     290 }
>
> regards,
> dan carpenter
