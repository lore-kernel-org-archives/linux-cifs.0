From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [Regression]  cifs: sanity check length of data to send before
 sending
Date: Tue, 23 Sep 2014 18:49:26 -0400
Message-ID: <20140923184926.2fdbb6c6@tlielax.poochiereds.net>
References: <5421C563.8070304@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Joseph Salisbury <joseph.salisbury-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5421C563.8070304-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 23 Sep 2014 15:09:23 -0400
Joseph Salisbury <joseph.salisbury-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:

> Hi Jeff,
> 
> A kernel bug report was opened against Ubuntu [0].  It was found that
> reverting the following commit resolved this bug:
> 
> 
> commit a26054d184763969a411e3939fe243516715ff59
> Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Fri Feb 14 07:21:00 2014 -0500
> 
>     cifs: sanity check length of data to send before sending
> 
>       
> The regression was introduced as of v3.14-rc7.
> 
> It appears the patch may be doing what it is supposed to, since the
> send_length != smb_buf_length:
> send_length=72
> and
> smb_buf_length=2164260932
> 
> However, without this check and WARN/return of -EIO the samba
> connections still work correctly.
> 
> I was hoping to get your feedback, since you are the patch author.  Do
> you think gathering any additional data will help diagnose this issue,
> or would it be best to submit a revert request?
>     
> Thanks,
>     
> Joe
> 
> [0] http://pad.lv/1372482
> 

(I'm no longer with Red Hat, so the jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org address won't
reach me any longer...)

It looks like you probably just need to merge
dca1c8d17a2feae056f9e334ea75a462ae4cb52a into your kernel as well.

Cheers,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
