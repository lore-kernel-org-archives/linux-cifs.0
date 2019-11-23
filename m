Return-Path: <SRS0=r/Fj=ZP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E54FC432C0
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Nov 2019 04:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F05922072D
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Nov 2019 04:02:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LVQXCz6N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfKWECv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Nov 2019 23:02:51 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:39355 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfKWECv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Nov 2019 23:02:51 -0500
Received: by mail-il1-f195.google.com with SMTP id a7so9238881ild.6
        for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2019 20:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=dj4OhgPiEhcA5z4mbEhXM/VxmCKgQvPwfAldaE2MCms=;
        b=LVQXCz6NhsYBzw8LhYTqO9nUPuyQNMMg5UKgfE46PBDKddIb4hX1yQoUZmjlLy26VD
         Nuqye8m8DRutG36Ne3Vz6nAo1hlhkduyHn9zfdlgCL78b5Ka41Zlnf7isRGTig60Z8uj
         Nen8RUyL+hFomjx4Aucycnylu87k5154qZ+mYGJ0suRIT1TuIF4H+Ax7xDATr+68v11S
         JMFarxgKZAkpQqCnOjvOTaxg+PeSbZaLYtjdhn0J+l0VS5kM4RmoA2oshnBQHj6qeBsn
         AR6nLHWoUJQg9VexSJAOUaT570uLwe0l9s1sMH18FFb0NLk45j2jrg5gYZRouEaDC/lE
         Tq+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=dj4OhgPiEhcA5z4mbEhXM/VxmCKgQvPwfAldaE2MCms=;
        b=aLwRlqSjTh4VyG6/0Qh44Eki6UiCXfJxTltGcPUf3dQ0L3ZiVK2CEy/9nZcxEBuJpY
         Bid3zDFY5YZgM+Iyab36IQldqQWO6zjt+/UkFuDsX+I6SAlTwM8L5F+kcVB5FG9S1iQh
         oPrBP1z3Lg1lZ7QipCu4HlsKg5XlKnvQ36j6F5X5jcqWuFU8JB0xCNSAh/9l81CiHe/v
         Ildu+TI33mC3lLDzCH6evB8Cep4jvksYAJHBkrxODZy1xyKfgPwi+vVolpJfSfSh9xeG
         BMA6WHJmmmlhpBJsFn6g9jQs4Y2upDxqu316P1TXtLbMZIzbZWbLoo00C+C00vzOib0X
         V48Q==
X-Gm-Message-State: APjAAAVdXPz1FZtkwUBwIg61hZG0B6uN8XRMLyRjKReS1/PX82uj7ibO
        JpOruwQwcQc28Ka1aSUNR3y1J7ILKndeU/HH9Cc=
X-Google-Smtp-Source: APXvYqz9hl7xkE8ROm9b+vYxw+4xSEYNYGxtbQ6RY+73ytysCs5Ak8EUkoMqp9ol4hN2GXpv5yc0We4MUkNPjikwlo8=
X-Received: by 2002:a6b:6e14:: with SMTP id d20mr5335553ioh.173.1574481769725;
 Fri, 22 Nov 2019 20:02:49 -0800 (PST)
MIME-Version: 1.0
References: <201911230953.7DJUrhXJ%lkp@intel.com>
In-Reply-To: <201911230953.7DJUrhXJ%lkp@intel.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 22 Nov 2019 22:02:38 -0600
Message-ID: <CAH2r5mv0p7H72gGQ-UcMQdxCLcQiYm6WTzN5-rtsq3zpNCNNkA@mail.gmail.com>
Subject: Re: [cifs:for-next 34/34] fs/cifs/cifs_debug.c:401:43: warning:
 format '%u' expects argument of type 'unsigned int', but argument 3 has type
 'size_t {aka long unsigned int}'
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

changed the %lu (for size_t max_channels) to %zu to avoid the 32 vs.
64 bit warning

On Fri, Nov 22, 2019 at 7:08 PM kbuild test robot <lkp@intel.com> wrote:
>
> tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> head:   9e6195fc0ac9d8e2c574e09ef4e12120a3746233
> commit: 9e6195fc0ac9d8e2c574e09ef4e12120a3746233 [34/34] cifs: dump channel info in DebugData
> config: x86_64-lkp (attached as .config)
> compiler: gcc-7 (Debian 7.4.0-14) 7.4.0
> reproduce:
>         git checkout 9e6195fc0ac9d8e2c574e09ef4e12120a3746233
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    fs/cifs/cifs_debug.c: In function 'cifs_debug_data_proc_show':
> >> fs/cifs/cifs_debug.c:401:43: warning: format '%u' expects argument of type 'unsigned int', but argument 3 has type 'size_t {aka long unsigned int}' [-Wformat=]
>         seq_printf(m, "\n\n\tExtra Channels: %u\n",
>                                              ~^
>                                              %lu
>             ses->chan_count-1);
>             ~~~~~~~~~~~~~~~~~
>
> vim +401 fs/cifs/cifs_debug.c
>
>    215
>    216  static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>    217  {
>    218          struct list_head *tmp1, *tmp2, *tmp3;
>    219          struct mid_q_entry *mid_entry;
>    220          struct TCP_Server_Info *server;
>    221          struct cifs_ses *ses;
>    222          struct cifs_tcon *tcon;
>    223          int i, j;
>    224
>    225          seq_puts(m,
>    226                      "Display Internal CIFS Data Structures for Debugging\n"
>    227                      "---------------------------------------------------\n");
>    228          seq_printf(m, "CIFS Version %s\n", CIFS_VERSION);
>    229          seq_printf(m, "Features:");
>    230  #ifdef CONFIG_CIFS_DFS_UPCALL
>    231          seq_printf(m, " DFS");
>    232  #endif
>    233  #ifdef CONFIG_CIFS_FSCACHE
>    234          seq_printf(m, ",FSCACHE");
>    235  #endif
>    236  #ifdef CONFIG_CIFS_SMB_DIRECT
>    237          seq_printf(m, ",SMB_DIRECT");
>    238  #endif
>    239  #ifdef CONFIG_CIFS_STATS2
>    240          seq_printf(m, ",STATS2");
>    241  #else
>    242          seq_printf(m, ",STATS");
>    243  #endif
>    244  #ifdef CONFIG_CIFS_DEBUG2
>    245          seq_printf(m, ",DEBUG2");
>    246  #elif defined(CONFIG_CIFS_DEBUG)
>    247          seq_printf(m, ",DEBUG");
>    248  #endif
>    249  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
>    250          seq_printf(m, ",ALLOW_INSECURE_LEGACY");
>    251  #endif
>    252  #ifdef CONFIG_CIFS_WEAK_PW_HASH
>    253          seq_printf(m, ",WEAK_PW_HASH");
>    254  #endif
>    255  #ifdef CONFIG_CIFS_POSIX
>    256          seq_printf(m, ",CIFS_POSIX");
>    257  #endif
>    258  #ifdef CONFIG_CIFS_UPCALL
>    259          seq_printf(m, ",UPCALL(SPNEGO)");
>    260  #endif
>    261  #ifdef CONFIG_CIFS_XATTR
>    262          seq_printf(m, ",XATTR");
>    263  #endif
>    264          seq_printf(m, ",ACL");
>    265          seq_putc(m, '\n');
>    266          seq_printf(m, "CIFSMaxBufSize: %d\n", CIFSMaxBufSize);
>    267          seq_printf(m, "Active VFS Requests: %d\n", GlobalTotalActiveXid);
>    268          seq_printf(m, "Servers:");
>    269
>    270          i = 0;
>    271          spin_lock(&cifs_tcp_ses_lock);
>    272          list_for_each(tmp1, &cifs_tcp_ses_list) {
>    273                  server = list_entry(tmp1, struct TCP_Server_Info,
>    274                                      tcp_ses_list);
>    275
>    276  #ifdef CONFIG_CIFS_SMB_DIRECT
>    277                  if (!server->rdma)
>    278                          goto skip_rdma;
>    279
>    280                  if (!server->smbd_conn) {
>    281                          seq_printf(m, "\nSMBDirect transport not available");
>    282                          goto skip_rdma;
>    283                  }
>    284
>    285                  seq_printf(m, "\nSMBDirect (in hex) protocol version: %x "
>    286                          "transport status: %x",
>    287                          server->smbd_conn->protocol,
>    288                          server->smbd_conn->transport_status);
>    289                  seq_printf(m, "\nConn receive_credit_max: %x "
>    290                          "send_credit_target: %x max_send_size: %x",
>    291                          server->smbd_conn->receive_credit_max,
>    292                          server->smbd_conn->send_credit_target,
>    293                          server->smbd_conn->max_send_size);
>    294                  seq_printf(m, "\nConn max_fragmented_recv_size: %x "
>    295                          "max_fragmented_send_size: %x max_receive_size:%x",
>    296                          server->smbd_conn->max_fragmented_recv_size,
>    297                          server->smbd_conn->max_fragmented_send_size,
>    298                          server->smbd_conn->max_receive_size);
>    299                  seq_printf(m, "\nConn keep_alive_interval: %x "
>    300                          "max_readwrite_size: %x rdma_readwrite_threshold: %x",
>    301                          server->smbd_conn->keep_alive_interval,
>    302                          server->smbd_conn->max_readwrite_size,
>    303                          server->smbd_conn->rdma_readwrite_threshold);
>    304                  seq_printf(m, "\nDebug count_get_receive_buffer: %x "
>    305                          "count_put_receive_buffer: %x count_send_empty: %x",
>    306                          server->smbd_conn->count_get_receive_buffer,
>    307                          server->smbd_conn->count_put_receive_buffer,
>    308                          server->smbd_conn->count_send_empty);
>    309                  seq_printf(m, "\nRead Queue count_reassembly_queue: %x "
>    310                          "count_enqueue_reassembly_queue: %x "
>    311                          "count_dequeue_reassembly_queue: %x "
>    312                          "fragment_reassembly_remaining: %x "
>    313                          "reassembly_data_length: %x "
>    314                          "reassembly_queue_length: %x",
>    315                          server->smbd_conn->count_reassembly_queue,
>    316                          server->smbd_conn->count_enqueue_reassembly_queue,
>    317                          server->smbd_conn->count_dequeue_reassembly_queue,
>    318                          server->smbd_conn->fragment_reassembly_remaining,
>    319                          server->smbd_conn->reassembly_data_length,
>    320                          server->smbd_conn->reassembly_queue_length);
>    321                  seq_printf(m, "\nCurrent Credits send_credits: %x "
>    322                          "receive_credits: %x receive_credit_target: %x",
>    323                          atomic_read(&server->smbd_conn->send_credits),
>    324                          atomic_read(&server->smbd_conn->receive_credits),
>    325                          server->smbd_conn->receive_credit_target);
>    326                  seq_printf(m, "\nPending send_pending: %x "
>    327                          "send_payload_pending: %x",
>    328                          atomic_read(&server->smbd_conn->send_pending),
>    329                          atomic_read(&server->smbd_conn->send_payload_pending));
>    330                  seq_printf(m, "\nReceive buffers count_receive_queue: %x "
>    331                          "count_empty_packet_queue: %x",
>    332                          server->smbd_conn->count_receive_queue,
>    333                          server->smbd_conn->count_empty_packet_queue);
>    334                  seq_printf(m, "\nMR responder_resources: %x "
>    335                          "max_frmr_depth: %x mr_type: %x",
>    336                          server->smbd_conn->responder_resources,
>    337                          server->smbd_conn->max_frmr_depth,
>    338                          server->smbd_conn->mr_type);
>    339                  seq_printf(m, "\nMR mr_ready_count: %x mr_used_count: %x",
>    340                          atomic_read(&server->smbd_conn->mr_ready_count),
>    341                          atomic_read(&server->smbd_conn->mr_used_count));
>    342  skip_rdma:
>    343  #endif
>    344                  seq_printf(m, "\nNumber of credits: %d Dialect 0x%x",
>    345                          server->credits,  server->dialect);
>    346                  if (server->compress_algorithm == SMB3_COMPRESS_LZNT1)
>    347                          seq_printf(m, " COMPRESS_LZNT1");
>    348                  else if (server->compress_algorithm == SMB3_COMPRESS_LZ77)
>    349                          seq_printf(m, " COMPRESS_LZ77");
>    350                  else if (server->compress_algorithm == SMB3_COMPRESS_LZ77_HUFF)
>    351                          seq_printf(m, " COMPRESS_LZ77_HUFF");
>    352                  if (server->sign)
>    353                          seq_printf(m, " signed");
>    354                  if (server->posix_ext_supported)
>    355                          seq_printf(m, " posix");
>    356
>    357                  i++;
>    358                  list_for_each(tmp2, &server->smb_ses_list) {
>    359                          ses = list_entry(tmp2, struct cifs_ses,
>    360                                           smb_ses_list);
>    361                          if ((ses->serverDomain == NULL) ||
>    362                                  (ses->serverOS == NULL) ||
>    363                                  (ses->serverNOS == NULL)) {
>    364                                  seq_printf(m, "\n%d) Name: %s Uses: %d Capability: 0x%x\tSession Status: %d ",
>    365                                          i, ses->serverName, ses->ses_count,
>    366                                          ses->capabilities, ses->status);
>    367                                  if (ses->session_flags & SMB2_SESSION_FLAG_IS_GUEST)
>    368                                          seq_printf(m, "Guest\t");
>    369                                  else if (ses->session_flags & SMB2_SESSION_FLAG_IS_NULL)
>    370                                          seq_printf(m, "Anonymous\t");
>    371                          } else {
>    372                                  seq_printf(m,
>    373                                      "\n%d) Name: %s  Domain: %s Uses: %d OS:"
>    374                                      " %s\n\tNOS: %s\tCapability: 0x%x\n\tSMB"
>    375                                      " session status: %d ",
>    376                                  i, ses->serverName, ses->serverDomain,
>    377                                  ses->ses_count, ses->serverOS, ses->serverNOS,
>    378                                  ses->capabilities, ses->status);
>    379                          }
>    380                          if (server->rdma)
>    381                                  seq_printf(m, "RDMA\n\t");
>    382                          seq_printf(m, "TCP status: %d Instance: %d\n\tLocal Users To "
>    383                                     "Server: %d SecMode: 0x%x Req On Wire: %d",
>    384                                     server->tcpStatus,
>    385                                     server->reconnect_instance,
>    386                                     server->srv_count,
>    387                                     server->sec_mode, in_flight(server));
>    388
>    389                          seq_printf(m, " In Send: %d In MaxReq Wait: %d",
>    390                                  atomic_read(&server->in_send),
>    391                                  atomic_read(&server->num_waiters));
>    392
>    393                          /* dump session id helpful for use with network trace */
>    394                          seq_printf(m, " SessionId: 0x%llx", ses->Suid);
>    395                          if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
>    396                                  seq_puts(m, " encrypted");
>    397                          if (ses->sign)
>    398                                  seq_puts(m, " signed");
>    399
>    400                          if (ses->chan_count > 1) {
>  > 401                                  seq_printf(m, "\n\n\tExtra Channels: %u\n",
>    402                                             ses->chan_count-1);
>    403                                  for (j = 1; j < ses->chan_count; j++)
>    404                                          cifs_dump_channel(m, j, &ses->chans[j]);
>    405                          }
>    406
>    407                          seq_puts(m, "\n\tShares:");
>    408                          j = 0;
>    409
>    410                          seq_printf(m, "\n\t%d) IPC: ", j);
>    411                          if (ses->tcon_ipc)
>    412                                  cifs_debug_tcon(m, ses->tcon_ipc);
>    413                          else
>    414                                  seq_puts(m, "none\n");
>    415
>    416                          list_for_each(tmp3, &ses->tcon_list) {
>    417                                  tcon = list_entry(tmp3, struct cifs_tcon,
>    418                                                    tcon_list);
>    419                                  ++j;
>    420                                  seq_printf(m, "\n\t%d) ", j);
>    421                                  cifs_debug_tcon(m, tcon);
>    422                          }
>    423
>    424                          seq_puts(m, "\n\tMIDs:\n");
>    425
>    426                          spin_lock(&GlobalMid_Lock);
>    427                          list_for_each(tmp3, &server->pending_mid_q) {
>    428                                  mid_entry = list_entry(tmp3, struct mid_q_entry,
>    429                                          qhead);
>    430                                  seq_printf(m, "\tState: %d com: %d pid:"
>    431                                                " %d cbdata: %p mid %llu\n",
>    432                                                mid_entry->mid_state,
>    433                                                le16_to_cpu(mid_entry->command),
>    434                                                mid_entry->pid,
>    435                                                mid_entry->callback_data,
>    436                                                mid_entry->mid);
>    437                          }
>    438                          spin_unlock(&GlobalMid_Lock);
>    439
>    440                          spin_lock(&ses->iface_lock);
>    441                          if (ses->iface_count)
>    442                                  seq_printf(m, "\n\tServer interfaces: %zu\n",
>    443                                             ses->iface_count);
>    444                          for (j = 0; j < ses->iface_count; j++) {
>    445                                  struct cifs_server_iface *iface;
>    446
>    447                                  iface = &ses->iface_list[j];
>    448                                  seq_printf(m, "\t%d)", j);
>    449                                  cifs_dump_iface(m, iface);
>    450                                  if (is_ses_using_iface(ses, iface))
>    451                                          seq_puts(m, "\t\t[CONNECTED]\n");
>    452                          }
>    453                          spin_unlock(&ses->iface_lock);
>    454                  }
>    455          }
>    456          spin_unlock(&cifs_tcp_ses_lock);
>    457          seq_putc(m, '\n');
>    458
>    459          /* BB add code to dump additional info such as TCP session info now */
>    460          return 0;
>    461  }
>    462
>
> ---
> 0-DAY kernel test infrastructure                 Open Source Technology Center
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation



-- 
Thanks,

Steve
