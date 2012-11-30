From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs: clean up handling of unc= option commit
Date: Thu, 29 Nov 2012 20:02:08 -0500
Message-ID: <20121129200208.56653c6a@corrin.poochiereds.net>
References: <CAH2r5mtPsux7U3MpLxnNGDBQS7OdYqBeUXhS=XspyrUgsrrevg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtPsux7U3MpLxnNGDBQS7OdYqBeUXhS=XspyrUgsrrevg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 29 Nov 2012 18:17:14 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Jeff,
> In your patch "cifs: clean up handling of unc= option	commit" aren't
> you changing the parsing of not just the beginning of the UNC name to
> change //server/share to \\server/share (e.g.) but did you mean to
> change the parsing of the rest of the UNC name as well.  Doesn't
> convert delimiter change all occurrences not just the first) ?
> 

Yes, that's intentional.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
