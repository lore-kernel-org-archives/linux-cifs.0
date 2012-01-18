From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 2/4] cifs: sanitize username handling
Date: Wed, 18 Jan 2012 08:49:13 -0600
Message-ID: <CAH2r5mv4iL3XOZ+G8UQSxUd9bDKdkK-C9WKSJv3y9uQZXnmz4g@mail.gmail.com>
References: <1326836547-7011-1-git-send-email-jlayton@redhat.com>
	<1326836547-7011-3-git-send-email-jlayton@redhat.com>
	<CAH2r5msmuYW3+XZXecpan7jkBngy2hZBGMjfy+5C3hsNcWsavQ@mail.gmail.com>
	<20120118071005.77db7383@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120118071005.77db7383-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jan 18, 2012 at 6:10 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 17 Jan 2012 22:41:30 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Merged your patch series, but fixed two of the four checkpatch
>> warnings (one in this patch and one in following one).
>>
>
> Thanks. I just noticed one really minor thing. The description in
> commit 8a8798a still says it's looking for a "secret" key, when it's
> really looking for a "logon" key. The code is correct though. Let me
> know if you want me to respin that patch and fix the description.

It is probably fine as is.


-- 
Thanks,

Steve
