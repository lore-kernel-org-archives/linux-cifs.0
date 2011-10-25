From: Steve French <smfrench@gmail.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
Date: Tue, 25 Oct 2011 10:05:52 -0500
Message-ID: <CAH2r5mtkByKNPYN50ioRoS79sAR_rhShANcm9o-Qvo7S762VFg@mail.gmail.com>
References: <20111026005939.ad20ab7a2dacce216c69e821@canb.auug.org.au>
	<CAH2r5muLiYKCrS2f_DftZSnyuP0EC+vu99mENznCSL8ecnTkpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
	Linus <torvalds@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CAH2r5muLiYKCrS2f_DftZSnyuP0EC+vu99mENznCSL8ecnTkpg@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Corrected typo in proposed patch and merged to cifs-2.6.git

On Tue, Oct 25, 2011 at 9:51 AM, Steve French <smfrench@gmail.com> wrot=
e:
> Am fixing it now. =A0Jeff missed a stub for the non-freezer case.
>
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index a155561..cd2d55b 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -202,6 +202,8 @@ static inline void set_freezable_with_signal(void=
) {}
>
> =A0#define wait_event_freezable_timeout(wq, condition, timeout) =A0 =A0=
 =A0 =A0 =A0 \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wait_event_interruptible_timeout(wq, c=
ondition, timeout)
> +#define #define wait_event_freezekillable(wq, condition) =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_event_killable(wq, condition)
>
>
> On Tue, Oct 25, 2011 at 8:59 AM, Stephen Rothwell <sfr@canb.auug.org.=
au> wrote:
>> Hi all,
>>
>> After merging the cifs tree, today's linux-next build (powerpc
>> iseries_defconfig) failed like this:
>>
>> fs/cifs/transport.c: In function 'wait_for_response':
>> fs/cifs/transport.c:328: error: implicit declaration of function 'wa=
it_event_freezekillable'
>>
>> Caused by commit f06ac72e9291 ("cifs, freezer: add
>> wait_event_freezekillable and have cifs use it"). =A0In this config,
>> CONFIG_FREEZER is not set.
>> --
>> Cheers,
>> Stephen Rothwell =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sfr@canb.auu=
g.org.au
>> http://www.canb.auug.org.au/~sfr/
>>
>
>
>
> --
> Thanks,
>
> Steve
>



--=20
Thanks,

Steve
