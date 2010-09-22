From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/15] cifs: fix handling of signing with writepages
 (try #5)
Date: Wed, 22 Sep 2010 15:39:21 -0700
Message-ID: <20100922153921.1ae10875@corrin.poochiereds.net>
References: <1285190586-10750-1-git-send-email-jlayton@redhat.com>
	<AANLkTi=U25njqKFiGW2vO_uWMqQ52Xz9m+wigyW=AHez@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=U25njqKFiGW2vO_uWMqQ52Xz9m+wigyW=AHez-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 22 Sep 2010 17:29:12 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> The patch does seem to change one behavior.
> 
> If CIFSSMBWrite2 writes data, but less than requested
> (bytes written < bytes_to_write) this may change the file size but the
> (local copy of eof?) eof won't be updated in that case (as it was
> before)
> 

Good catch. I'll fix, retest and resend...
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
