From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] SMB3 Fixes
Date: Fri, 13 Nov 2015 18:48:23 -0600
Message-ID: <CAH2r5mvTtk70R8+Zc7OGeX3wAcXxW_jKzQnpvVqoLMru_V+udg@mail.gmail.com>
References: <CAH2r5mtPCXrTLS+eXvko7ofbT2VZLfqREyqcDKoUfychwfi_Tg@mail.gmail.com>
 <CA+55aFw7zSVnwQuC2CXy3Gx1zL-UHfn2nqE=VZBEzgphHXrVXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFw7zSVnwQuC2CXy3Gx1zL-UHfn2nqE=VZBEzgphHXrVXg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Nov 13, 2015 at 6:43 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> So I pulled this, but:
>
> On Fri, Nov 13, 2015 at 1:24 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> I will have some additional patches for SMB3 encryption and SMB3.1.1
>> signing (important security features), and also for improving SMB3
>> persistent handle reconnection (setting ChannelSequence number e.g.)
>> that I am still working on but wanted to get this set in since they
>> can stand alone.
>
> So anything you intend to send this merge window and are still working
> on had better be really obvious and small, or clearly bug-fixes.
>
> It's Friday afternoon here, the merge window closes this weekend, and
> it's much too late to still be working on new features that you expect
> to get merged.

Understood.

I would like to get the security improvements in (at least SMB3.1.1 signing),
and they are close to ready but probably can't get the final patch
reviewed in time for Sunday.
The signing patch is about 150 lines of code, but needs one additional
patch and it probably won't be reviewed in time.

-- 
Thanks,

Steve
