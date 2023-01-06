Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD25C54E76
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Jan 2023 07:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjAFH7E (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 6 Jan 2023 02:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjAFH7C (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 6 Jan 2023 02:59:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3277878E80
        for <linux-cifs@vger.kernel.org>; Thu,  5 Jan 2023 23:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672991854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xmb3IcLHCLsi/xOiQHUkWYlXfS8doiaC8cJwdmVUFK4=;
        b=SLVzg7+qVCkSPwpEXCMyFeNPY9fsRC3J6m6t9JyyNaGFIjjHxovBVrdPL/kwwpyv/tLyr+
        uAEuds0xSUup0UDOyInIosfoE5Z2o/gfG+Wqj40CVNLzVuwrG63GucOn2dCZ3OWAJ+VClz
        dumlyhgYGDzQ/s+rMBR1O1MSWa7geiY=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-404-O3ISqbPyPE-MPNX15Yvcug-1; Fri, 06 Jan 2023 02:57:32 -0500
X-MC-Unique: O3ISqbPyPE-MPNX15Yvcug-1
Received: by mail-yb1-f200.google.com with SMTP id z17-20020a256651000000b007907852ca4dso1142567ybm.16
        for <linux-cifs@vger.kernel.org>; Thu, 05 Jan 2023 23:57:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xmb3IcLHCLsi/xOiQHUkWYlXfS8doiaC8cJwdmVUFK4=;
        b=IM2IMK/nuA+w5kKhJ//uTM7oAxOZo2gFMn54IRHnWX03LMVnKhv/QBrF1OKVpZaVg8
         lm70GqIgyHWeD/pr1aUDa9tgZGXfSZgaeX9NRdMZThXUhg1OnOieCmOdhy/fNnRQs5k2
         rLDEs6wRo9CYJHCo/w2bTcNI24xBJPRfTSFBxKb2l0jubFqCd/s8Xc7WT+VOjLfYckJZ
         DPByqbmbdAGsCsP9vMkmlJDBoNcefAJm+bSCy6Xi5gwM6Bb23jvNxY5DZGeDdNQnfvm8
         hoLrr6o4Ik75mdX6HCxuW8xmiITpAVKIkbvffkCVs960aSYc1nYUQBq2VOYVpPBtb0Tn
         Xs4w==
X-Gm-Message-State: AFqh2krSXT6KvXuPaRIIkIz6U/kj90ZLRwuNWn2EKyOJkubIMibstBOi
        hgw/ujEKv960zk0jc1of95URbe+1mj7nnzSsDg/TPP9dNgSOVV0WV87kNYkUAJN8nDVj4noUHKb
        6k8JEmjXmgyu5YNugOj4lheVh70dMjVLRDA2Uyg==
X-Received: by 2002:a05:690c:87:b0:46f:36b1:a27 with SMTP id be7-20020a05690c008700b0046f36b10a27mr4200654ywb.147.1672991851846;
        Thu, 05 Jan 2023 23:57:31 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuC/bbIcMr4bQ8ok16zXLqM2NrU98mA2WJd0uc+HAfHs8BnKxPTLzGpg1jIsSESD/q9eqv3v1Jyw7xgl7+RWvk=
X-Received: by 2002:a05:690c:87:b0:46f:36b1:a27 with SMTP id
 be7-20020a05690c008700b0046f36b10a27mr4200651ywb.147.1672991851590; Thu, 05
 Jan 2023 23:57:31 -0800 (PST)
MIME-Version: 1.0
References: <20230104211448.4804-1-vishal.moola@gmail.com> <20230104211448.4804-18-vishal.moola@gmail.com>
In-Reply-To: <20230104211448.4804-18-vishal.moola@gmail.com>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Fri, 6 Jan 2023 08:57:20 +0100
Message-ID: <CAHc6FU55EfV0qvtpPUWAvHm72kPd7Rzb8=-GX0oFgfJonXt7Pg@mail.gmail.com>
Subject: Re: [Cluster-devel] [PATCH v5 17/23] gfs2: Convert
 gfs2_write_cache_jdata() to use filemap_get_folios_tag()
To:     "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, ceph-devel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jan 4, 2023 at 10:15 PM Vishal Moola (Oracle)
<vishal.moola@gmail.com> wrote:
> Converted function to use folios throughout. This is in preparation for
> the removal of find_get_pgaes_range_tag(). This change removes 8 calls
> to compound_head().
>
> Also had to modify and rename gfs2_write_jdata_pagevec() to take in
> and utilize folio_batch rather than pagevec and use folios rather
> than pages. gfs2_write_jdata_batch() now supports large folios.
>
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  fs/gfs2/aops.c | 64 +++++++++++++++++++++++++++-----------------------
>  1 file changed, 35 insertions(+), 29 deletions(-)
>
> diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
> index e782b4f1d104..0a47068f9acc 100644
> --- a/fs/gfs2/aops.c
> +++ b/fs/gfs2/aops.c
> @@ -195,67 +195,71 @@ static int gfs2_writepages(struct address_space *mapping,
>  }
>
>  /**
> - * gfs2_write_jdata_pagevec - Write back a pagevec's worth of pages
> + * gfs2_write_jdata_batch - Write back a folio batch's worth of folios
>   * @mapping: The mapping
>   * @wbc: The writeback control
> - * @pvec: The vector of pages
> - * @nr_pages: The number of pages to write
> + * @fbatch: The batch of folios
>   * @done_index: Page index
>   *
>   * Returns: non-zero if loop should terminate, zero otherwise
>   */
>
> -static int gfs2_write_jdata_pagevec(struct address_space *mapping,
> +static int gfs2_write_jdata_batch(struct address_space *mapping,
>                                     struct writeback_control *wbc,
> -                                   struct pagevec *pvec,
> -                                   int nr_pages,
> +                                   struct folio_batch *fbatch,
>                                     pgoff_t *done_index)
>  {
>         struct inode *inode = mapping->host;
>         struct gfs2_sbd *sdp = GFS2_SB(inode);
> -       unsigned nrblocks = nr_pages * (PAGE_SIZE >> inode->i_blkbits);
> +       unsigned nrblocks;
>         int i;
>         int ret;
> +       int nr_pages = 0;
> +       int nr_folios = folio_batch_count(fbatch);
> +
> +       for (i = 0; i < nr_folios; i++)
> +               nr_pages += folio_nr_pages(fbatch->folios[i]);
> +       nrblocks = nr_pages * (PAGE_SIZE >> inode->i_blkbits);
>
>         ret = gfs2_trans_begin(sdp, nrblocks, nrblocks);
>         if (ret < 0)
>                 return ret;
>
> -       for(i = 0; i < nr_pages; i++) {
> -               struct page *page = pvec->pages[i];
> +       for (i = 0; i < nr_folios; i++) {
> +               struct folio *folio = fbatch->folios[i];
>
> -               *done_index = page->index;
> +               *done_index = folio->index;
>
> -               lock_page(page);
> +               folio_lock(folio);
>
> -               if (unlikely(page->mapping != mapping)) {
> +               if (unlikely(folio->mapping != mapping)) {
>  continue_unlock:
> -                       unlock_page(page);
> +                       folio_unlock(folio);
>                         continue;
>                 }
>
> -               if (!PageDirty(page)) {
> +               if (!folio_test_dirty(folio)) {
>                         /* someone wrote it for us */
>                         goto continue_unlock;
>                 }
>
> -               if (PageWriteback(page)) {
> +               if (folio_test_writeback(folio)) {
>                         if (wbc->sync_mode != WB_SYNC_NONE)
> -                               wait_on_page_writeback(page);
> +                               folio_wait_writeback(folio);
>                         else
>                                 goto continue_unlock;
>                 }
>
> -               BUG_ON(PageWriteback(page));
> -               if (!clear_page_dirty_for_io(page))
> +               BUG_ON(folio_test_writeback(folio));
> +               if (!folio_clear_dirty_for_io(folio))
>                         goto continue_unlock;
>
>                 trace_wbc_writepage(wbc, inode_to_bdi(inode));
>
> -               ret = __gfs2_jdata_writepage(page, wbc);
> +               ret = __gfs2_jdata_writepage(&folio->page, wbc);
>                 if (unlikely(ret)) {
>                         if (ret == AOP_WRITEPAGE_ACTIVATE) {
> -                               unlock_page(page);
> +                               folio_unlock(folio);
>                                 ret = 0;
>                         } else {
>
> @@ -268,7 +272,8 @@ static int gfs2_write_jdata_pagevec(struct address_space *mapping,
>                                  * not be suitable for data integrity
>                                  * writeout).
>                                  */
> -                               *done_index = page->index + 1;
> +                               *done_index = folio->index +
> +                                       folio_nr_pages(folio);
>                                 ret = 1;
>                                 break;
>                         }
> @@ -305,8 +310,8 @@ static int gfs2_write_cache_jdata(struct address_space *mapping,
>  {
>         int ret = 0;
>         int done = 0;
> -       struct pagevec pvec;
> -       int nr_pages;
> +       struct folio_batch fbatch;
> +       int nr_folios;
>         pgoff_t writeback_index;
>         pgoff_t index;
>         pgoff_t end;
> @@ -315,7 +320,7 @@ static int gfs2_write_cache_jdata(struct address_space *mapping,
>         int range_whole = 0;
>         xa_mark_t tag;
>
> -       pagevec_init(&pvec);
> +       folio_batch_init(&fbatch);
>         if (wbc->range_cyclic) {
>                 writeback_index = mapping->writeback_index; /* prev offset */
>                 index = writeback_index;
> @@ -341,17 +346,18 @@ static int gfs2_write_cache_jdata(struct address_space *mapping,
>                 tag_pages_for_writeback(mapping, index, end);
>         done_index = index;
>         while (!done && (index <= end)) {
> -               nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
> -                               tag);
> -               if (nr_pages == 0)
> +               nr_folios = filemap_get_folios_tag(mapping, &index, end,
> +                               tag, &fbatch);
> +               if (nr_folios == 0)
>                         break;
>
> -               ret = gfs2_write_jdata_pagevec(mapping, wbc, &pvec, nr_pages, &done_index);
> +               ret = gfs2_write_jdata_batch(mapping, wbc, &fbatch,
> +                               &done_index);
>                 if (ret)
>                         done = 1;
>                 if (ret > 0)
>                         ret = 0;
> -               pagevec_release(&pvec);
> +               folio_batch_release(&fbatch);
>                 cond_resched();
>         }
>
> --
> 2.38.1
>

Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>

Thanks,
Andreas

