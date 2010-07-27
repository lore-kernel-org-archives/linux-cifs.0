From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: document 'fsc' mount option
Date: Tue, 27 Jul 2010 11:38:20 -0500
Message-ID: <AANLkTi=+Y1XdFCT1UfWZW==qusXfs6t-vxa_CYo03TTT@mail.gmail.com>
References: <4C4EE408.7070109@suse.de>
	<20100727103313.4b730ea8@tlielax.poochiereds.net>
	<AANLkTina2EyHkrgNAcrY8ZRK=fXQS71dekWc+kOA0+mz@mail.gmail.com>
	<20100727111517.4fe0859e@tlielax.poochiereds.net>
	<AANLkTik9JqtqAtKJQsaQR8aC8s0kwmrcU=_=QQei7U07@mail.gmail.com>
	<4C4F0A71.8020908@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton@redhat.com>, linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Suresh Jayaraman <sjayaraman@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C4F0A71.8020908@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Jul 27, 2010 at 11:33 AM, Suresh Jayaraman <sjayaraman@suse.de>=
 wrote:
> On 07/27/2010 08:51 PM, Steve French wrote:
>> scripts/extract-ikconfig could be run against the image (or look at
>> /proc/config.gz) - but unless there is an easier way to view kernel
>> config options on particular distros via distro specific tools -
>> probably easier just to note that CONFIG_FSCACHE must be selected in
>> the kernel build (since it forces dependencies on the other kernel
>> options being set)
>
> Does something like
> =A0 =A0 =A0 =A0$zcat /proc/config.gz | grep CONFIG_CIFS_FSCACHE
>
> might work on all distros?
>
> But, Jeff's idea of having a features file in /proc sounds good. Apar=
t
> from using them as a reference to check in documentation, it could be=
 a
> useful information while collecting debugging output as well..?

Seems reasonable - but wondering if other file systems have run into th=
e same
problem - how to view their build/config options - and how they have
solved it (if at all) so ccing fsdevel



--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
