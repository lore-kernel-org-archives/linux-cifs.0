Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18580C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Mar 2022 05:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiC2FOU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Mar 2022 01:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiC2FOT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Mar 2022 01:14:19 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C25E30F50
        for <linux-cifs@vger.kernel.org>; Mon, 28 Mar 2022 22:12:37 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id w7so28306047lfd.6
        for <linux-cifs@vger.kernel.org>; Mon, 28 Mar 2022 22:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=rcE4dlO/r/LBx/VuDzntxwx7U1uRH4xX1ELddUVECqw=;
        b=ZK/L/ggx9Xltku8c6GcTrBbYA/JC1cdTbcm2/F4oD9ii35MJ0j0v2vP8M1stTrb3Gp
         NFdjrPpI87c7GZJX1rzl6WVIWMtWL0L+OqTcpTGDb/h7xz5g9ykdCkRh7mRqnCK0SUvv
         V7PRPueBwd64i7ohDc5/9akkFSSIUcE92dFyPOXvwBNPK/AfM19WsWKtpkAc+Gl6FQ1S
         M+Sf8naHTERieEkWu97m5f2GpY6acGgFtuVE9R7z5CzVpnrYdEfSuRPuP2gc3JOp8rhK
         Wtlk5khI1ripb/YaLaBM8SwdiydbrWvyhzLcfSdShM0q9pmCabxInAg8ZnsUiuxIhfL3
         rXEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=rcE4dlO/r/LBx/VuDzntxwx7U1uRH4xX1ELddUVECqw=;
        b=kRmftXvJBkF2GgXUr8UDa0Q3RJ4MmD4+wtADZGPYeheQ8ECcV92sSUj/t2kyjYSdam
         CEV7Eo2hhCaqxlUQKGEFxC1hVN8oQcml+1rPCkE8kd8bNSKW5MYNq0fmiaS67O+Eno/C
         NqmE3a3Uf9IJ4vkZhmp8y+ulL9jM2RiufzFNJey1Uk1xd7//6xgkCL/h7UTkAaO1+vb2
         QA6QisP4aEZSE2Gc5szT63zoaQo3BDxXswHpacK620Fv+1CNm6Jgdat03yKXtG/rUpd+
         glg3I6yqd+ykNdjtU6opLQVbn1RE8lRwm07VYrmJsT0+JUfxb7nnvbjRJo/hMHkEMO0t
         z50w==
X-Gm-Message-State: AOAM5331V6qRlY7D6D191UZ+SWc8unsZ7Z10aDRy+uU58VOpla44738v
        OPBthXAT+Etw1sEcu6Qs+/ZkTwJpzjFR3zpUJqcWneG3Ldg=
X-Google-Smtp-Source: ABdhPJyOe6xzoBvRIeO7UdUMa9zU+NtgN5+CbLU+UvAwLvm62sxRXfGpUe1+vKJNwsgG/gzRyvvZ8+kz1RUhTll23vo=
X-Received: by 2002:a05:6512:130c:b0:44a:2dd3:91d0 with SMTP id
 x12-20020a056512130c00b0044a2dd391d0mr1035595lfu.234.1648530754994; Mon, 28
 Mar 2022 22:12:34 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 29 Mar 2022 00:12:24 -0500
Message-ID: <CAH2r5mudrWoDMz_mLQtBxE5baEU2M-9G8n+LM0roDc=C=XVBfQ@mail.gmail.com>
Subject: Detailed analysis of how tree connect state is handled in cifs.ko
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Did a detailed analysis of the 24 functions where we set or check the
tcon status (or need_reconnect).   Detailed analysis below.  There is
some overlap between TID_NEED_RECON and need_reconnect,
but generally the "TID_NEED_RECON" and "TID_NEED_FILES_INVALIDATE"
status are set more
generally by the equivalent boolean, but other status changes are
handled by the tid status enum.

Eight tree connect struct status values are defined for tcon->status
cifsglob.h:122: TID_NEW = 0,
cifsglob.h:123: TID_GOOD,
cifsglob.h:124: TID_EXITING,
cifsglob.h:125: TID_NEED_RECON,
cifsglob.h:126: TID_NEED_TCON,
cifsglob.h:127: TID_IN_TCON,
cifsglob.h:128: TID_NEED_FILES_INVALIDATE, /* currently unused */
cifsglob.h:129: TID_IN_FILES_INVALIDATE

and also a partially overlapping bool tcon->need_reconnect is defined,
and another one called tcon->need_reopen_files

The 23 functions which set or check these statuses are listed below:

1) cifs_umount_begin()
checks if other umount in progress, holds tcp_ses_lock
cifsfs.c:702: if ((tcon->tc_count > 1) || (tcon->status == TID_EXITING)) {
cifsfs.c:709: tcon->status = TID_EXITING;

2) cifs_mark_open_files_invalid()
holds tcp_set_lock
returns if TID_NEED_RECON already set, or if session status not CifsGood
otherwise sets TID_IN_FILES_INVALIDATE, marks the files as invalidHandle
unlocks then locks again to check if TID_IN_FILES_INVALIDATE is still set
then sets TID_NEED_TCON.  May be missing call to invalidate inodes on the sb
cifssmb.c:82: tcon->status = TID_IN_FILES_INVALIDATE;
cifssmb.c:102: if (tcon->status == TID_IN_FILES_INVALIDATE)
cifssmb.c:103: tcon->status = TID_NEED_TCON;

3) cifs_reconnect_tcon()
if TID_EXITING then doesn't allow Write or Open or Tree Disconnect
to be sent (holding tcp_ses_lock), and later it checks tcon->need_reconnect
(and exits without sending the tcon if it is not set).
Before sending negotiate, it checks if chan_needs_reconnect is not set
but no tcon needs to be sent (tcon->need_reconnect not set). And finally
after session setup (if it needed to be sent), before sending the tcon
(and marking the open files invalid) it checks need_reconnect once more
to see if it is really needed
cifssmb.c:138: if (tcon->status == TID_EXITING) {
cifssmb.c:191: if (!cifs_chan_needs_reconnect(ses, server) &&
!tcon->need_reconnect) {
cifssmb.c:221: if (tcon->need_reconnect)
cifssmb.c:235: if (rc || !tcon->need_reconnect) {

4) smb_init_no_reconnect()
if tcon->need_reconnect set then it doesn't do the __smb_init and
just returns EHOSTDOWN
cifssmb.c:382:     tcon->need_reconnect) {

5) CIFSSMBTDis()
while holding the chan lock it sees if tcon->need_reconnect and
if so returns EIO instead of sending the tree disconnect
cifssmb.c:650: if ((tcon->need_reconnect) ||
CIFS_ALL_CHANS_NEED_RECONNECT(tcon->ses)) {

6) cifs_mark_tcp_ses_conns_for_reconnect()
while holding tcp_ses_lock marks all ses structs as CifsNeedReconnect
and also marks all of the tcon structs they contain as TID_NEED_RECON
and need_reconnect
connect.c:247: tcon->need_reconnect = true;
connect.c:248: tcon->status = TID_NEED_RECON;
connect.c:251: ses->tcon_ipc->need_reconnect = true;


7) match_tcon()
Returns immediately (no match) if TID_EXITING set
connect.c:2210: if (tcon->status == TID_EXITING)

8) __tree_connect_dfs_target()
If ipc$ needs reconnect it connects that before doing the DFS share connect
connect.c:4402: if (ipc->need_reconnect) {

9) cifs_tree_connect()   [DFS enabled version]
While holding tcp_ses_lock sets tcon status as TID_IN_TCON
and if tree connect fails, sets tcon status again as TID_NEED_TCON
else if status is still TID_IN_TCON (presumably to see if reconnect
occurred after tcon in other thread) sets TID_GOOD and also
sets tcon->need_reconnect false
(holding the tcp_ses_lock)
connect.c:4494: tcon->status = TID_IN_TCON;
connect.c:4535: if (tcon->status == TID_IN_TCON)
connect.c:4536: tcon->status = TID_NEED_TCON;
connect.c:4540: if (tcon->status == TID_IN_TCON)
connect.c:4541: tcon->status = TID_GOOD;
connect.c:4543: tcon->need_reconnect = false;

10) cifs_tree_connect()  [non-DFS version]
similar logic to above other version of cifs_tree_connect
connect.c:4562: tcon->status = TID_IN_TCON;
connect.c:4568: if (tcon->status == TID_IN_TCON)
connect.c:4569: tcon->status = TID_NEED_TCON;
connect.c:4573: if (tcon->status == TID_IN_TCON)
connect.c:4574: tcon->status = TID_GOOD;
connect.c:4576: tcon->need_reconnect = false;

11) tconInfoAlloc()
sets TID_NEW when tcon buffer created, no lock needed since not in list yet
misc.c:119: ret_buf->status = TID_NEW;

12) smb2_compound_op()
if error EREMCHG returned from sending compound op then set need_reconnect
(EREMCHG is mapped from STATUS_NETWORK_NAME_DELETED)
smb2inode.c:384: tcon->need_reconnect = true;

13) open_cached_dir()
if error EREMCHG returned from sending compound op then set need_reconnect
smb2ops.c:890: tcon->need_reconnect = true;

14) smb2_is_network_name_deleted()
if STATUS_NETWORK_NAME_DELETED then set need_reconnect to true
(can be called from demultiplex_thread on error e.g.)
smb2ops.c:2541: tcon->need_reconnect = true;

15) smb2_query_info_compound()
similar to the above 3 examples
smb2ops.c:2746: tcon->need_reconnect = true;

16) smb2_reconnect()
checks if TID_EXITING, if so doesn't allow WRITE, CREATE, or TDIS
if tcon->need_reconnect not needed will return 0 (early)
if chan_needs_reconnect_not_set and tcon->need_reconnect can
skip session session setup, and finally just before marking files
invalid (and setting need_reopen_files to true) and sending the
tree_connect if tcon->need_reconnect not set then can exit
without having to send the tcon
smb2pdu.c:166: if (tcon->status == TID_EXITING) {
smb2pdu.c:243: if (!cifs_chan_needs_reconnect(ses, server) &&
!tcon->need_reconnect) {
smb2pdu.c:250: cifs_dbg(FYI, "tcon reconnect: %d", tcon->need_reconnect);
smb2pdu.c:276: if (tcon->need_reconnect)
smb2pdu.c:300: if (!tcon->need_reconnect) {
smb2pdu.c:306:          tcon->need_reopen_files = true;

17) SMB2_tcon()
if sending tree connect failed mark tcon->need_reconnect as true
smb2pdu.c:1891: tcon->need_reconnect = true;

18) SMB2_tdis()
If need_reconnect set, no need to send tree disconnect request
smb2pdu.c:1961: if ((tcon->need_reconnect) ||

19) SMB2_open()
if error EREMCHG (STATUS_NETWORK_NAME_DELETED) returned from open
then set need_reconnect to true
smb2pdu.c:3003: tcon->need_reconnect = true;

20) smb2_reconnect_server()
tcons with need_reconnect or need_reopen_files set are added to
tmp_list with the tcon->rlist (the tree connection's reconnect list).
Then allocates a dummy tcon used for reconnect, and sets it to TID_GOOD,
and its need_reconnect to false then frees it (doesn't hold
tcp_ses_lock but probably not needed)
smb2pdu.c:3799: if (tcon->need_reconnect || tcon->need_reopen_files) {
smb2pdu.c:3809: if (ses->tcon_ipc && ses->tcon_ipc->need_reconnect) {
smb2pdu.c:3863: tcon->status = TID_GOOD;
smb2pdu.c:3865: tcon->need_reconnect = false;

21) cifs_debug_tcon() and cifs_stats_proc_show()
Prints DISCONNECTED if need_reconnect is set to aid debugging
cifs_debug.c:120: if (tcon->need_reconnect)
cifs_debug.c:624: if (tcon->need_reconnect)

22) refresh_mounts()
goes through all sockets, servers and tcons, and if tcon doesn't
need_reconnect then adds it to tail of cache update list (tcon->ulist)
dfs_cache.c:1518: if (!tcon->ipc && !tcon->need_reconnect) {

23) _cifsFileInfo_put()
if tcon->need_reconnect set then don't need to close the file
file.c:489: if (!tcon->need_reconnect && !cifs_file->invalidHandle) {

24) cifs_reopen_persistent_handles()
if need_reopen_files set then returns immediately, else sets
need_reopen_files to false
(unless error returned reopening a file)
file.c:936:     if (!tcon->use_persistent || !tcon->need_reopen_files)
file.c:939:     tcon->need_reopen_files = false;
file.c:958:                     tcon->need_reopen_files = true;

-- 
Thanks,

Steve
