From: Steve French <smfrench@gmail.com>
Subject: Re: [RFC PATCH 01/09] Introduce offset for the 1st page in data
 transfer structures
Date: Fri, 18 May 2018 01:37:40 -0500
Message-ID: <CAH2r5mv7uqBWaetBPZLV2GWJTk=85CQMLsjfD=kDknnhmx6f1A@mail.gmail.com>
References: <20180518002214.5657-1-longli@linuxonhyperv.com> <20180518002214.5657-2-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
To: Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518002214.5657-2-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, May 17, 2018 at 7:22 PM, Long Li <longli@linuxonhyperv.com> wrote:
> From: Long Li <longli@microsoft.com>
>
> Currently CIFS allocates its own pages for data transfer, they don't need offset
> since it's always 0 in the 1st page.
>
> Direct data transfer needs to define an offset because user-data may not start
> on the page boundary
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/cifsglob.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index cb950a5..a51855c 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -176,6 +176,7 @@ struct smb_rqst {
>         struct kvec     *rq_iov;        /* array of kvecs */
>         unsigned int    rq_nvec;        /* number of kvecs in array */
>         struct page     **rq_pages;     /* pointer to array of page ptrs */
> +       unsigned int    rq_offset;      /* the offset to the 1st page */
>         unsigned int    rq_npages;      /* number pages in array */
>         unsigned int    rq_pagesz;      /* page size to use */
>         unsigned int    rq_tailsz;      /* length of last page */
> @@ -1167,8 +1168,10 @@ struct cifs_readdata {
>         struct kvec                     iov[2];
>  #ifdef CONFIG_CIFS_SMB_DIRECT
>         struct smbd_mr                  *mr;
> +       struct page                     **direct_pages;
>  #endif
>         unsigned int                    pagesz;
> +       unsigned int                    page_offset;
>         unsigned int                    tailsz;
>         unsigned int                    credits;
>         unsigned int                    nr_pages;
> @@ -1192,8 +1195,10 @@ struct cifs_writedata {
>         int                             result;
>  #ifdef CONFIG_CIFS_SMB_DIRECT
>         struct smbd_mr                  *mr;
> +       struct page                     **direct_pages;
>  #endif
>         unsigned int                    pagesz;
> +       unsigned int                    page_offset;
>         unsigned int                    tailsz;
>         unsigned int                    credits;
>         unsigned int                    nr_pages;
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
