Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 801AAC433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Nov 2021 10:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65EDE61131
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Nov 2021 10:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhKIKse (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Nov 2021 05:48:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230101AbhKIKsd (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 9 Nov 2021 05:48:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3741261131
        for <linux-cifs@vger.kernel.org>; Tue,  9 Nov 2021 10:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636454748;
        bh=FXsklt23pe5vGAzwhx326ezBBw90Ec+nY3t/5ZyU9WQ=;
        h=From:Date:Subject:To:Cc:From;
        b=sV4ROzmnWkb4Vsvlvk7x1vbpzndqNZGk+hxPvrMxKVVi/g42fMjeTKsUMDmR0lwlg
         3/AfZ1QBGYCxWDytKj5gE58Z4HQpfHFLDlOnltH9sPIID0y9wHJqcEt4uxz7LUInSE
         2qO9Rye4RRUxMNtUGxRTmMN+MnOIINd+hPlSmrjZ/xTQGAoL6cfb7HFZ6DWFboHrwx
         SjPhT9wm3Q+SiCNfsnpwcUDrwXJ0a1Bd1T5JSZcrptuNBy7qCIParSSoEl9I+5vb6a
         o/zzHBMdeL6D2a81jMYVhYJoWib/uF5CSgX7Gz2TcO0iF4M8Ht6jkF4tDrJPG6WNwS
         7QdNVqdEF9KiQ==
Received: by mail-ot1-f50.google.com with SMTP id x19-20020a9d7053000000b0055c8b39420bso9629048otj.1
        for <linux-cifs@vger.kernel.org>; Tue, 09 Nov 2021 02:45:48 -0800 (PST)
X-Gm-Message-State: AOAM530/JRjiimI/grs3YfVsgnetIV8twiVLg906uIanYYb3hmG0VwbE
        4hIUZthFhgO3qul0mKB/DX28wy/kDfwvRV5BieQ=
X-Google-Smtp-Source: ABdhPJwH1KAKZXWhPRh9PDd+qxoakVhO+D2BG084eOooi94rWNP1WONqIhF8Tac2i25f8kuHvAYvW2X41KB44fYF+d8=
X-Received: by 2002:a9d:6653:: with SMTP id q19mr5127667otm.116.1636454747495;
 Tue, 09 Nov 2021 02:45:47 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:4448:0:0:0:0:0 with HTTP; Tue, 9 Nov 2021 02:45:47 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 9 Nov 2021 19:45:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8KvqTQ-RnmWPFChmMEKGw9zA37chPM0H=FSewfRqx1zA@mail.gmail.com>
Message-ID: <CAKYAXd8KvqTQ-RnmWPFChmMEKGw9zA37chPM0H=FSewfRqx1zA@mail.gmail.com>
Subject: Hitting BUG_ON trap in read_pages() - : [PATCH v2] mm: Optimise put_pages_list()
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Steve French <smfrench@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Matthew,

This patch is hitting BUG_ON trap in read_pages() when running
xfstests for cifs.
There seems to be a same issue with other filesystems using .readpages ?
Could you please take a look ?

[ 1007.298234] ------------[ cut here ]------------
[ 1007.298237] kernel BUG at mm/readahead.c:151!
[ 1007.298244] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[ 1007.298248] CPU: 4 PID: 35188 Comm: fio Not tainted 5.15.0+ #2
[ 1007.298250] Hardware name: ASUSTeK COMPUTER INC. Z10PA-D8
Series/Z10PA-D8 Series, BIOS 3801 08/23/2019
[ 1007.298252] RIP: 0010:read_pages+0x247/0x250
[ 1007.298259] Code: 07 48 c1 e8 33 83 e0 07 83 f8 04 75 c4 48 8b 47
08 8b 40 68 83 e8 01 83 f8 01 77 b5 e8 b2 26 00 00 eb b4 e8 fb 25 00
00 eb ad <0f> 0b 0f 0b e8 10 0f 9b 00 0f 1f 44 00 00 55 48 89 e5 41 57
41 56
[ 1007.298261] RSP: 0018:ffffa3ae21ea7a98 EFLAGS: 00010287
[ 1007.298263] RAX: ffffcc5dc5e21c08 RBX: ffffa3ae21ea7c40 RCX: 0000000000000000
[ 1007.298265] RDX: ffffcc5dc5e21c00 RSI: 0000000000000000 RDI: ffffa3ae21ea7a98
[ 1007.298267] RBP: ffffa3ae21ea7af0 R08: 0000000000000000 R09: ffffa3ae21ea7960
[ 1007.298268] R10: ffff9474afb37598 R11: 0000000000000000 R12: ffffa3ae21ea7b38
[ 1007.298269] R13: 0000000000000000 R14: ffffffffc0de2220 R15: ffff94719dc4c328
[ 1007.298271] FS:  00007fc94d3f5880(0000) GS:ffff9474afb00000(0000)
knlGS:0000000000000000
[ 1007.298273] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1007.298274] CR2: 00005635fb61c000 CR3: 000000013b2ac006 CR4: 00000000001706e0
[ 1007.298276] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1007.298277] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1007.298279] Call Trace:
[ 1007.298280]  <TASK>
[ 1007.298283]  page_cache_ra_unbounded+0x16b/0x230
[ 1007.298287]  do_page_cache_ra+0x3d/0x40
[ 1007.298290]  force_page_cache_ra+0x7c/0xb0
[ 1007.298293]  page_cache_sync_ra+0x3e/0xd0
[ 1007.298295]  filemap_get_pages+0xe5/0x770
[ 1007.298297]  ? __switch_to_asm+0x36/0x70
[ 1007.298303]  filemap_read+0xd0/0x3e0
[ 1007.298305]  ? preempt_count_add+0x74/0xc0
[ 1007.298310]  ? kvfree+0x28/0x30
[ 1007.298316]  ? cifs_aio_ctx_release+0xd1/0xe0 [cifs]
[ 1007.298362]  generic_file_read_iter+0xf0/0x160
[ 1007.298365]  cifs_strict_readv+0xea/0x100 [cifs]
[ 1007.298391]  new_sync_read+0x113/0x1a0
[ 1007.298395]  vfs_read+0xfe/0x1a0
[ 1007.298398]  ksys_read+0x67/0xe0
[ 1007.298401]  __x64_sys_read+0x1a/0x20
[ 1007.298404]  do_syscall_64+0x3b/0xc0
[ 1007.298408]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1007.298412] RIP: 0033:0x7fc956d1a36c

2021-10-08 4:21 GMT+09:00, Matthew Wilcox (Oracle) <willy@infradead.org>:
> Instead of calling put_page() one page at a time, pop pages off
> the list if their refcount was too high and pass the remainder to
> put_unref_page_list().  This should be a speed improvement, but I have
> no measurements to support that.  Current callers do not care about
> performance, but I hope to add some which do.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
> v2:
>  - Handle compound pages (Mel)
>  - Comment why we don't need to handle PageLRU
>  - Added call to __ClearPageWaiters(), matching that in release_pages()
>
>  mm/swap.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
>
> diff --git a/mm/swap.c b/mm/swap.c
> index af3cad4e5378..9f334d503fd2 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -134,18 +134,27 @@ EXPORT_SYMBOL(__put_page);
>   * put_pages_list() - release a list of pages
>   * @pages: list of pages threaded on page->lru
>   *
> - * Release a list of pages which are strung together on page.lru.
> Currently
> - * used by read_cache_pages() and related error recovery code.
> + * Release a list of pages which are strung together on page.lru.
>   */
>  void put_pages_list(struct list_head *pages)
>  {
> -	while (!list_empty(pages)) {
> -		struct page *victim;
> +	struct page *page, *next;
>
> -		victim = lru_to_page(pages);
> -		list_del(&victim->lru);
> -		put_page(victim);
> +	list_for_each_entry_safe(page, next, pages, lru) {
> +		if (!put_page_testzero(page)) {
> +			list_del(&page->lru);
> +			continue;
> +		}
> +		if (PageHead(page)) {
> +			list_del(&page->lru);
> +			__put_compound_page(page);
> +			continue;
> +		}
> +		/* Cannot be PageLRU because it's passed to us using the lru */
> +		__ClearPageWaiters(page);
>  	}
> +
> +	free_unref_page_list(pages);
>  }
>  EXPORT_SYMBOL(put_pages_list);
>
> --
> 2.32.0
>
>
