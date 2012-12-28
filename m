From: spameden <spameden-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: question about cifs mount timeouts and reconnects
Date: Fri, 28 Dec 2012 13:20:56 +0400
Message-ID: <CAHCALew2KzsYVK3LFOW1+PpSUKJemtKjSM+=_0mQymqvvUR6dQ@mail.gmail.com>
References: <CAHCALewKCtX9G6Cy4Qu0Fn0BqCh0nW89aGsamuF40t9Nr32Fsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHCALewKCtX9G6Cy4Qu0Fn0BqCh0nW89aGsamuF40t9Nr32Fsw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi.

I've been using samba/cifs for years and now noticed various hangs
occuring on reconnection.

Here is an example of situation when it occurs:

1. host A have shared directory "share", host A is running MS Windows.
(for example - a laptop)
2. host B got directory "share" mounted under /mnt/share, host B is
running Debian Linux Squeeze with 3.2 backported kernel with latest
updates installed.

If host A reboots and after successful reboot you'd try to access
/mnt/share on host B - host B hangs on that dir for 60-300seconds
(sometimes even longer).

I understand the hang if it could happen in situation where "share" on
host A is no longer available, but it's available (the only thing -
host was rebooted!).

What I've tried so far:

1) I've tried using "soft" option on mount - didnt help at all (I
believe its set by default, but added anyways to the fstab mounting
options)
2) tried inserting cifs module with echo_retries=1 - didnt help still
the same thing
3) tried on 2.6.32 kernel as well (debian's default kernel) -
absolutely same behaviour, thought it's fixed in 3.2.0-0.bpo.4-amd64
backported kernel.

It's very annoying and inconvinient to have this behavior every time
host reboots.

Please suggest if it's distro specific bug or samba's "by design bug"?
