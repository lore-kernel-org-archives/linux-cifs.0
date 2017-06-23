From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: set mapping error when page writeback fails in
 writepage or launder_pages
Date: Fri, 23 Jun 2017 02:15:01 -0500
Message-ID: <CAH2r5msT4P1iY3B1n7ZDpq8A+QSjfGk-fE1NO0P0_5mRSFhj6g@mail.gmail.com>
References: <20170525105952.8867-1-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170525105952.8867-1-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, May 25, 2017 at 5:59 AM, Jeff Layton <jlayton@redhat.com> wrote:
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  fs/cifs/file.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 0fd081bd2a2f..5009860dbdc6 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2234,14 +2234,16 @@ cifs_writepage_locked(struct page *page, struct writeback_control *wbc)
>         set_page_writeback(page);
>  retry_write:
>         rc = cifs_partialpagewrite(page, 0, PAGE_SIZE);
> -       if (rc == -EAGAIN && wbc->sync_mode == WB_SYNC_ALL)
> -               goto retry_write;
> -       else if (rc == -EAGAIN)
> +       if (rc == -EAGAIN) {
> +               if (wbc->sync_mode == WB_SYNC_ALL)
> +                       goto retry_write;
>                 redirty_page_for_writepage(wbc, page);
> -       else if (rc != 0)
> +       } else if (rc != 0) {
>                 SetPageError(page);
> -       else
> +               mapping_set_error(page->mapping, rc);
> +       } else {
>                 SetPageUptodate(page);
> +       }
>         end_page_writeback(page);
>         put_page(page);
>         free_xid(xid);
> --
> 2.9.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
