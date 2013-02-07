From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: bugfix for unreclaimed writeback pages in cifs_writev_requeue()
Date: Thu, 7 Feb 2013 11:27:40 +0400
Message-ID: <CAKywueRgnbL5vnGCAvcJexbaSu_VEFathM=CKFOTPtz9Ygmdzw@mail.gmail.com>
References: <CAKywueTQ0q=B2pw1HjWZLXe27DVbydx-0c7ZJUHCJMUcBMMtvA@mail.gmail.com>
	<OFA5D50D9D.206122F1-ON48257B0B.00139BCC-48257B0B.002214B3@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	wang.liang82-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, ouyang.maochun-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org,
	cai.qu-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, jiang.yong5-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org,
	zhang.xianwei8-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org
To: jiang.biao2-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OFA5D50D9D.206122F1-ON48257B0B.00139BCC-48257B0B.002214B3-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/2/7  <jiang.biao2-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>:
>> I think we should do end_page_writeback(wdata->pages[i]) and
>> page_cache_release(wdata->pages[i]) regardless whether rc is 0 or not
>> (we are doing the same things in cifs_writev_complete now). Thoughts?
> Actually,if rc=0 in cifs_writev_requeue, end_page_writeback(wdata->pages[i])
> and
> page_cache_release(wdata->pages[i]) have been done in cifs_writev_complete,
> and we
> should not worry about that.What we need fix here is the situation when
> rc!=0.

Ok. We go into cifs_writev_complete with wdata->sync_mode ==
WB_SYNC_ALL and wdata->result == -EAGAIN. In this case we call
cifs_write_requeue:

} else if (wdata->sync_mode == WB_SYNC_ALL && wdata->result == -EAGAIN)
        return cifs_writev_requeue(wdata);"

end_page_writeback and page_cache_release are called after the
statement above - so, if we hit in cifs_writev_requeue, they are not
called anymore. That's why we should call them from
cifs_writev_requeue unconditionally.

-- 
Best regards,
Pavel Shilovsky.
