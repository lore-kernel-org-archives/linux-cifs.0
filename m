From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mid structures cifs vs. smb2
Date: Fri, 11 Mar 2011 18:29:54 -0600
Message-ID: <AANLkTi=faCm65kdBkxKkWwqFp3Zr-p+H5275Bd59M3G7@mail.gmail.com>
References: <AANLkTi=O_D90MxzG81V6==8GDc78mPrBW=+6ERLwKmwr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=O_D90MxzG81V6==8GDc78mPrBW=+6ERLwKmwr-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Mar 11, 2011 at 6:00 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Thinking over Jeff's comments I have done the following to make it easier to
> read/review and cleanup:
> - removed the now unneeded field that Jeff noted

One more of the SMB2 mid fields is probably going
to be removed soon.

I had forgot to mention that one of the currently common
fields between the cifs and smb2 mid structures, the
sequence_number (used for cifs packet signing), is
apparently not needed for the better HMAC-SHA256
based signing mechanism used for SMB2,
but IIRC Shirish had not gotten
far enough in the SMB2 signing code to verify 100%
whether this can be removed until signing is tested.

This should help shrink the structure even more.

-- 
Thanks,

Steve
