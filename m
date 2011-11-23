From: NamJae Jeon <linkinjeon@gmail.com>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
Date: Wed, 23 Nov 2011 19:34:10 +0900
Message-ID: <CAKYAXd965Md2D4mnDbROoNcKZPQs2dERh8y7aDHtoJ+FJcK1QQ@mail.gmail.com>
References: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
	<81357503-810A-477A-A320-D39F2CD69547@cam.ac.uk>
	<20111103134056.178ee9e3@barsoom.rdu.redhat.com>
	<A2505FE2-FE28-4C23-879E-357C9D3AA03F@cam.ac.uk>
	<CAH2r5mtye1DHKbPYMKnkcZjfVKBqek=a7DWGPJvxCsoLEhzDXA@mail.gmail.com>
	<CAKYAXd98n+zPJPhuNXrtUNZjukXODNFQzLVPJKyP-+QKiYbQiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	LKML <linux-kernel@vger.kernel.org>,
	Unix Support <unix-support@ucs.cam.ac.uk>,
	Steve French <smfrench@gmail.com>, akpm@linux-foundation.org,
	Anton Altaparmakov <aia21@cam.ac.uk>, ashishsangwan2@gmail.com
To: stern@rowland.harvard.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKYAXd98n+zPJPhuNXrtUNZjukXODNFQzLVPJKyP-+QKiYbQiA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi. Alan.
Would you know why there is no upper/lower case table in nls utf8 ?
And Currently Surrogate pair is not supported also in nls utf8. Is
there the reason ?

2011/11/4 NamJae Jeon <linkinjeon@gmail.com>:
> 2011/11/4 Steve French <smfrench@gmail.com>:
>> What is the actual sequence of events from the wire perspective (the
>> actual smb requests sent)?
>>
>>
>> On Thu, Nov 3, 2011 at 6:25 PM, Anton Altaparmakov <aia21@cam.ac.uk>=
 wrote:
>>> Hi,
>>>
>>> On 3 Nov 2011, at 17:40, Jeff Layton wrote:
>>>> On Thu, 3 Nov 2011 15:42:13 +0000 Anton Altaparmakov <aia21@cam.ac=
=2Euk> wrote:
>>>>>
>>>>> I should add that we are using iocharset=3Dutf8 mount option whic=
h means that the dcache hash/compare functions done in the cifs module =
do not work because it uses nls_tolower() and nls_strnicmp() both of wh=
ich for utf8 NLS in the kernel do not do anything at all and effectivel=
y behave case sensitively!
>>>>>
>>>>> Thus this bug/problem in all likelyhood only affects utf8 iochars=
et users on a case-insensitive but case-preserving CIFS server that doe=
s not support server inode numbers.
>
> Hi.
> There is no upper/lower case table on nls utf8. so If you use iochars=
et=3Dutf8,
> filesystem will be case sensitive.
> so we can add upper/lower case table like other charset.
> And Currently surrogate pair is not working on nls utf8.
> because it is limited by MAX_WCHAR_T in nls utf8
> I think that upper/lower case table and surrogate pair support should
> be fixed on nls utf8.
> I should know Andrew's opinion to fix these problem.
>>>>>
>>>>> That probably explains why it has not been noticed before!
>>>>>
>>>>> We need utf8 thus we still need to fix this issue.
>>>
>>>> I'm confused...
>>>>
>>>> If the filesystem being served out by the server is using utf8, th=
en
>>>> how is it handling the case-insensitivity?
>>>
>>>
>>> The file system being served is NSS (the Netware one but now mounte=
d on Open Enterprise Server with Linux kernel rather than actual Netwar=
e kernel). =C2=A0No idea how it works I am afraid. =C2=A0It supports lo=
ts of different namespaces as well as being case-insensitive and case p=
reserving when using the LONG name space (which is now being served thr=
ough CIFS).
>>>
>>> If it was NTFS or exFAT I could tell you exactly how they work (eac=
h volume has an upcase table mapping the 65536 UCS-2 Unicode characters=
 to their upper case equivalents and each 16-bit character is upper-cas=
ed individually, more recently Windows has switched to using UTF-16 ins=
tead of UCS-2 and the upcase table changed when that happened though it=
 remained the same size and I think for file system purposes the fact t=
hat there are surrogates in the above UCS-2 =C2=A0 Unicode range is sim=
ply ignored)...
>>>
>>> Best regards,
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Anton
>>> --
>>> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
>>> Unix Support, Computing Service, University of Cambridge, CB2 3QH, =
UK
>>> Linux NTFS maintainer, http://www.linux-ntfs.org/
>>>
>>>
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kern=
el" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>>
>
