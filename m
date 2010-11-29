From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 0/6] Add strict cache mode (try #4)
Date: Mon, 29 Nov 2010 17:45:24 +0530
Message-ID: <4CF3995C.4080709@suse.de>
References: <1290931972-2770-1-git-send-email-piastryyy@gmail.com>	<4CF3864E.50901@suse.de> <AANLkTinLbS7V=Ok_Eje=mnrBOkZEJJo9iQ9SYwHsbsag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinLbS7V=Ok_Eje=mnrBOkZEJJo9iQ9SYwHsbsag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/29/2010 04:30 PM, Pavel Shilovsky wrote:
> 2010/11/29 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>:
>> On 11/28/2010 01:42 PM, Pavel Shilovsky wrote:
>>> Re-posting the whole set of strict cache patches.
>>
>> I try to explain here the "strict cache" semantics as I'm not sure
>> whether I understand it clearly. Please correct me if I'm wrong.
>>
>> Strict cache semantics
>>
>> =EF=BF=BDo provides stricter cache coherency among cifs clients that=
 access
>> =EF=BF=BD =EF=BF=BDthe same files.
>> =EF=BF=BDo The clients will read data from the Server always, except=
 when they
>> =EF=BF=BD =EF=BF=BDhold read oplock or Level II oplock on the file.
>> =EF=BF=BDo The clients will write data to the Server always, except =
when they
>> =EF=BF=BD =EF=BF=BDhold exclusive oplock on the file.
>> =EF=BF=BDo When we close the last filehandle of the inode, file shou=
ld be
>> =EF=BF=BD =EF=BF=BDmarked for revalidation as it is possible for the=
 client to access
>> =EF=BF=BD =EF=BF=BDstale data from the cache when we open it again w=
ith a read
>> =EF=BF=BD =EF=BF=BDoplock.
>> =EF=BF=BDo On fsync/mmap, invalidate inode if read oplock has not be=
en set.
>>
>>
>> Is this the semantics being proposed? Did I miss anything?
>=20
> Yes, you are right - it is exactly what I mean.
>=20

Also, would be good to know what level of testing these patches have
undergone. Could you share the test results as well?


Thanks,

--=20
Suresh Jayaraman
