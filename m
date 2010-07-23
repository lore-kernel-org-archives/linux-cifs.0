From: Stef Bon <stefbon@gmail.com>
Subject: Re: [PATCH 00/09] cifs: local caching support using FS-Cache
Date: Fri, 23 Jul 2010 10:35:55 +0200
Message-ID: <AANLkTikF5Oz5pobaPUJebUg+yPuoVy_B5PBz+nuUTSii@mail.gmail.com>
References: <4C480F51.8070204@suse.de>
	<1278333663-30464-1-git-send-email-sjayaraman@suse.de>
	<4C3DF6BF.3070001@gmail.com>
	<AANLkTin2tKtkWTflrrzBMYBEd6SFr35uYUl1SmfYlj9W@mail.gmail.com>
	<4C3F35F7.8060408@suse.de>
	<1892.1279820400@redhat.com>
	<A55FDF07-DC44-4A5D-BDC4-ACC7D76CC753@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Howells <dhowells@redhat.com>,
	Suresh Jayaraman <sjayaraman@suse.de>,
	Steve French <smfrench@gmail.com>,
	Scott Lovenberg <scott.lovenberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-cachefs@redhat.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <A55FDF07-DC44-4A5D-BDC4-ACC7D76CC753@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

In my opinion there should be article published about this, describing
fs-cache generally, and these kinds of benchmarks!

Using fs-cache for network filesystem is an important issue, and
should get "exposure".

Stef Bon

2010/7/23 Andreas Dilger <adilger@dilger.ca>:
> On 2010-07-22, at 11:40, David Howells wrote:
>> Suresh Jayaraman <sjayaraman@suse.de> wrote:
>>> As it can been seen, the performance while reading when data is cac=
he
>>> hot (disk) is not great as the network link is a Gigabit ethernet (=
with
>>> server having working set in memory) which is mostly expected.
>>
>> That's what I see with NFS and AFS too.
>>
>>> (I could not get access to a slower network (say 100 Mb/s) where th=
e real
>>> performance boost could be evident).
>
> More interesting than a slow network is testing with more clients. =C2=
=A010 clients should be able to get 10x the read performance from the c=
lient-local cache, probably more than the server's peak disk/network ba=
ndwidth.
>
> Cheers, Andreas
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
