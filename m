From: <a.biardi-IWqWACnzNjyonA0d6jMUrA@public.gmane.org>
Subject: Re: filenames with special chars and posix path caps enabled -
 regression?
Date: Fri, 19 Aug 2016 11:03:14 +0000
Message-ID: <20160819110314.24f6f1ae@alice.paese.meraviglie>
References: <20160720164341.1c3a518b@alice.paese.meraviglie>
        <CAH2r5mtR5u+3XtGPcL8MrXgQanB6YjCHDA9PmOo2w+sJgvpdJg@mail.gmail.com>
        <20160720173448.6d079f3c@alice.paese.meraviglie>
        <20160815104301.7d3ac8c9@alice.paese.meraviglie>
        <CAH2r5mtj0VBQkTrS5OQ5N5m5n7gjt_ottCShadtxR8tb-_JbqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtj0VBQkTrS5OQ5N5m5n7gjt_ottCShadtxR8tb-_JbqQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 15 Aug 2016 10:48:56 -0500, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
wrote:

> When mounting with newer dialects (vers=2.1 or vers=3 to get SMB2.1 or
> SMB3 support for example), or when mounting with CIFS to servers like
> Windows, the protocol dialect does not support these reserved
> characters, so by default we mount with posixpath mapping enabled to
> support mapping (posixpaths) of reserved characters to the SFM
> reserved range (same as Windows Services for Mac and the Mac itself
> does).  The result is that you can create and read the filenames
> remotely and they look fine but on the Samba server itself the
> reserved character will look strange since it is remapped.

Steve, thanks so much for your time and effort. And, you're right: in
fact, if I mount a share and create a file on it with one of those
reserved characters in the name, I can see that the actual filename on
the linux server has some "funny" characters in it.

Now I also understand why ls works (shows filenames as reported by the
server) while "cat" won't (client remaps characters, and server can't
locate a file with the remapped name).

> You could turn off posixpaths on mount (noposixpaths) on your cifs
> mount to see if this fixes it [...]

Didn't work for me; however, looking at the kernel source I found that
there is a "nomapposix" option that seems to do the trick. If I use
this option, I can read and write filenames with reserved characters
without any mapping.

Reason why this escaped me in the first place is that "mapposix" is not
documented in the mount.cifs manpage..

> [...] but the key will be looking at the mount options that were
> passed in to the kernel so we can see if you are mounting with
> posixpath mapping (which would force posixpaths to be mapped even
> though the server would have supported them without mapping)

Googling around, I came across this post
https://lists.samba.org/archive/samba-technical/2014-September/102671.html
so now I'm a bit confused as to what the default behavior should be.. I
thought my client/kernel would negotiate unix extensions by default
with a samba server, therefore no mapping would occur by default, but
apparently MAC-style mapping is now the default on linux too?

Andrea.
