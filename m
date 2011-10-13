From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifsacl and smb2
Date: Thu, 13 Oct 2011 14:34:19 -0500
Message-ID: <CADT32eJeZjMHpt4Hr8=sOGb0LHSbakHhAHjCYzD5souYW0EwOg@mail.gmail.com>
References: <CAH2r5mtakiZu0VTLBu_NyskKXEbuVg+7hWHrXRQo1Utc=JUK0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtakiZu0VTLBu_NyskKXEbuVg+7hWHrXRQo1Utc=JUK0g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 13, 2011 at 1:54 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I would like to default to cifsacl enabled for smb2 (eventually), at
> least until the unix extensions are ready, but realize we can't turn
> that on yet.
>
> Any reasons to not do cifsacl (this is similar to what macos and
> solaris, and windows SFU do IIRC)?
>
> --
> Thanks,
>
> Steve
>

I think we need equivalent of get/set security descriptor
commands (coded) in smb2 at the minimum.
