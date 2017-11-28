From: Yale Zhang <yzhang1985-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SMB 2 & later leaves files in bad inconsistent state
Date: Tue, 28 Nov 2017 03:24:34 -0800
Message-ID: <CALQF7Zwk7HGGkU0MXLGrSrA7JHwQP5m1e3U2J6_5O0A7+uJfzw@mail.gmail.com>
References: <CALQF7ZyjHDqW+8WiA=Xo3-he6jdVtse+ULme2zj9CJm8G5jX_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALQF7ZyjHDqW+8WiA=Xo3-he6jdVtse+ULme2zj9CJm8G5jX_g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Can anyone help?

On Sat, Nov 18, 2017 at 7:55 PM, Yale Zhang <yzhang1985-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I'm having a very annoying problem when compiling my code on GNU/Linux
> that's mounted from a Windows 10 desktop.
>
> When I press Ctrl-C to interrupt make, sometimes it leaves the object
> or executable files in a bad inconsistent state. The file cannot be
> deleted on Linux or Windows until you reboot Windows, a huge
> productivity killer.
>
> If you try to see the file's owner, it's undefined, which explains why
> it can't be deleted. See 1st screenshot.
>
>
> I used lsof to check if anyone is holding on to that file, but no one.
> I also used ProcessExplorer to check on the server side and found the
> "system" process holding it. For some reason, I can't forcefully close
> that file. See 2nd screenshot.
>
> So is this a problem with the SMB client or server? Any work arounds
> besides switching back to CIFS?
>
> -Yale
