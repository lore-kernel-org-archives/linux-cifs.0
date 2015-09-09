From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GiT] CIFS Fixes
Date: Wed, 9 Sep 2015 11:21:57 -0700
Message-ID: <CA+55aFw6VU9B6OBafJGTzq7dS-XQQE_syWY1mmg6R5UsPDKM7g@mail.gmail.com>
References: <CAH2r5mvkcq1S8iLEZDNmvZiFpiEJT5fBo_g2zg_VQ2KRMLtrhA@mail.gmail.com>
	<CA+55aFw9KB3iLZvCWfUT20vxsLovqUWEOjY51HjYf2ooEp2THw@mail.gmail.com>
	<CAH2r5mufnYU3pgOXi3sjUtFonMDzus+krvrS9i6w-cZHE9bQZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mufnYU3pgOXi3sjUtFonMDzus+krvrS9i6w-cZHE9bQZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 9, 2015 at 11:16 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Wed, Sep 9, 2015 at 12:02 PM, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>>
>> Ugh. With the ioctl changes, I was really hoping for the fix to
>> cifs_ioctl_clone() from Jann. But it's not there.
>>
>> Did that get lost somehow?
>
> I don't see any recent patch to cifs_ioctl_clone on fsdevel or
> linux-cifs. Do you have a link to it?

It was cc'd to you directly.

  From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
  Subject: Re: type confusion: also CIFS?
  Message-ID: <20150906181336.GA3896-J1fxOzX/cBvk1uMJSBkQmQ@public.gmane.org>
  Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

I'll bounce you a copy of it separately just in case.

              Linus
