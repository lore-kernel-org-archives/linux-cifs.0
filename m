From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SMB2 test suite question
Date: Wed, 25 Feb 2015 13:54:59 -0600
Message-ID: <CAH2r5mt_-aXXoQO5avHBfxf-ehmtgJRn2ezjFzv3S5eUmawvPw@mail.gmail.com>
References: <20150225193952.IPZQ7.90116.root@cdptpa-web04>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Charlie B." <charlie8-COjJCXVPnPBBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150225193952.IPZQ7.90116.root@cdptpa-web04>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

For tests of the Linux client that would be xfstest (which subsumes
many of the useful smaller functional tests of file systems), as it is
for most Linux file systems, but there are others such as dbench which
are particularly useful for constructing stress scenarios.

For tests of the server, most would prefer smbtorture but this is the
wrong mailing list to ask about Samba server questions.  Try
samba-technical

On Wed, Feb 25, 2015 at 1:39 PM, Charlie B. <charlie8-COjJCXVPnPBBDgjK7y7TUQ@public.gmane.org> wrote:
> Hello,
>      I was wondering if anyone could tell me the location of the best and most comprehensive SMB2 test suites would be.  Possibly V4 smbtorture?  Thank you for any advice!
>
> ~Charlie B.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
