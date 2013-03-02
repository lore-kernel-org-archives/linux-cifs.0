From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: bugfix for unreclaimed writeback pages in cifs_writev_requeue()
Date: Sat, 2 Mar 2013 09:53:23 +0400
Message-ID: <CAKywueRhn7=yN5f0zVdZ=458qu54GY_9mFTFgn810SPn-bhgvg@mail.gmail.com>
References: <OF08391DB5.0DFF1FA3-ON48257B0A.002333BE-48257B0A.002372B2@zte.com.cn>
	<CAH2r5muZL8voikW6NO_KojjV=N9zVymsqcR_KMf=XgZ4v8oGgQ@mail.gmail.com>
	<CAKywueTQ0q=B2pw1HjWZLXe27DVbydx-0c7ZJUHCJMUcBMMtvA@mail.gmail.com>
	<CAKywueRidM=aOdnxVsA3r0q33R7QnG1W87Eio6KiFOvTQB-ESQ@mail.gmail.com>
	<20130301185750.66a139ca@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130301185750.66a139ca-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/3/2 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Fri, 1 Mar 2013 22:08:04 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2013/2/6 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> >> diff -uprN linux-3.8-rc6/fs/cifs/cifssmb.c linux-3.8-rc6_new/fs/cifs/cifssmb.c
>> >> --- linux-3.8-rc6/fs/cifs/cifssmb.c        2013-02-01 09:08:14.000000000 +0800
>> >> +++ linux-3.8-rc6_new/fs/cifs/cifssmb.c        2013-02-04
>> >> 15:44:09.869254397 +0800
>> >> @@ -1909,8 +1909,11 @@ cifs_writev_requeue(struct cifs_writedat
>> >>          } while (rc == -EAGAIN);
>> >>
>> >>          for (i = 0; i < wdata->nr_pages; i++) {
>> >> -                if (rc != 0)
>> >> +                if (rc != 0){
>> >>                          SetPageError(wdata->pages[i]);
>> >> +                         end_page_writeback(wdata->pages[i]);
>> >> +                         page_cache_release(wdata->pages[i]);
>> >> +                 }
>> >
>> > I think we should do end_page_writeback(wdata->pages[i]) and
>> > page_cache_release(wdata->pages[i]) regardless whether rc is 0 or not
>> > (we are doing the same things in cifs_writev_complete now). Thoughts?
>> >
>> >>                  unlock_page(wdata->pages[i]);
>> >>          }
>> >>
>>
>> Jeff, what do you think about my comments to this patch
>> (http://git.samba.org/?p=sfrench/cifs-2.6.git;a=commitdiff;h=c51bb0ea40ca038da26b1fa7d450f4078124af03)
>> ? It doesn't clear to me why we should call
>> end_page_writeback(wdata->pages[i]) and
>> page_cache_release(wdata->pages[i]) in rc != 0 case only...
>>
>
> It's a good question, so I'll go ahead and cc the mailing list since
> there's no need to keep this private:
>
> ----------------[snip]---------------
>         do {
>                 server = tlink_tcon(wdata->cfile->tlink)->ses->server;
>                 rc = server->ops->async_writev(wdata);
>         } while (rc == -EAGAIN);
>
>         for (i = 0; i < wdata->nr_pages; i++) {
>                 if (rc != 0)
>                         SetPageError(wdata->pages[i]);
>                 unlock_page(wdata->pages[i]);
>         }
> ----------------[snip]---------------
>
> rc != 0 there means that resending the write failed with a
> non-retryable error. In that case, we need to end the writeback on it
> and release the reference we hold on it since the code is "finished"
> with the page at that point. We don't expect a reply from the server,
> so we need to make sure we clean up properly here.
>
> If rc == 0 however, then there is now a new write request in progress.
> The normal async reply handling will take care of it at that point. So
> we need to continue to hold on to the page reference, and the writeback
> bit still needs to stay set.

Ah, thanks - now I understand why it's so. Sorry for that noise.

In this case, I agree with the patch. Steve, you can leave my
"reviewed-by" tag there.

-- 
Best regards,
Pavel Shilovsky.
