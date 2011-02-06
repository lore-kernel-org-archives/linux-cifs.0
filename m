From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Sun, 6 Feb 2011 14:06:13 -0600
Message-ID: <AANLkTi=6BR3i-n8uTiKawE6FttREGeX6_zX-dhcsdZUR@mail.gmail.com>
References: <AANLkTimnN_LKnGdVgqBC0rMBVApN+Qn5bzOzv28Y=9eh@mail.gmail.com>
	<20110206134420.75ddcd5e@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110206134420.75ddcd5e-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Feb 6, 2011 at 12:44 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Sun, 6 Feb 2011 10:45:33 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> The following changes since commit afe8a887550f7cc24eb16449670b93f6b=
43c32d8:
>>
>> =A0 Merge branch 'next' of git://git.monstr.eu/linux-2.6-microblaze
>> (2011-02-02 10:23:58 +1100)
>>
>> are available in the git repository at:
>>
>> =A0 git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.g=
it master
>>
>> Jeff Layton (3):
>> =A0 =A0 =A0 cifs: fix length vs. total_read confusion in cifs_demult=
iplex_thread
>> =A0 =A0 =A0 cifs: enable signing flag in SMB header when server has =
it on
>> =A0 =A0 =A0 cifs: don't send an echo request unless NegProt has been=
 done
>>
>
> I don't think the last patch is quite ready, which is why I haven't
> posted it to the list. In any case, I have some follow-on patches tha=
t
> should fix it. Pushing to Linus now is fine, but we'll need to follow
> up with another one soon.

I agree, but the last patch does resolve the most obvious issue behind
the extraneous SMB echos, and the "enable signing" flag patch is
important to get upstream.

> Also, are you planning to push this patch to Linus in the near future=
?
>
> =A0 =A0cifs: don't always drop malformed replies on the floor

Yes, probably in next few days.  I only had the minor question about
whether you wanted to update one of the comments
(after the discussion about why 48 bytes was chosen).

--=20
Thanks,

Steve
