From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: mention the required kernel version to make
 cifs.idmap work
Date: Thu, 20 Oct 2011 22:29:07 -0500
Message-ID: <CAH2r5msY8goYA=KCA+7YUdFJ_K3YoY5BYBa1SnT36bAN0cYTFQ@mail.gmail.com>
References: <4E9C19A3.8010009@suse.de>
	<20111017081139.564089db@tlielax.poochiereds.net>
	<CAH2r5msxArv-Hdy6sBVGbNtLcjhwk0EUwGj07H85iOT4KHqiRg@mail.gmail.com>
	<20111017130654.53fd42c4@corrin.poochiereds.net>
	<4E9D17AA.8020407@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: sjayaraman-l3A5Bk7waGM@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E9D17AA.8020407-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Yes - I agree we should bring changes file up to date.

Patches welcome :)

(and also review of any of Pavel's smb2 patches would be great,
starting from the beginning would be good - I have gone through these,
especially the parts that hit existing cifs files and looks better
shape than I expected and I am pleased, or review 4 remaining lock
patches also would be a big help)

On Tue, Oct 18, 2011 at 1:07 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> =
wrote:
> On 10/17/2011 10:36 PM, Jeff Layton wrote:
>> On Mon, 17 Oct 2011 11:59:20 -0500
>> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> On Mon, Oct 17, 2011 at 7:11 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
>>>> On Mon, 17 Oct 2011 17:33:47 +0530
>>>> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>>>>
>>>>> .. properly in the "NOTES" section.
>>>>>
>>>>> Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>>>>> ---
>>>>> =A0cifs.idmap.8.in | =A0 =A03 +++
>>>>> =A01 files changed, 3 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/cifs.idmap.8.in b/cifs.idmap.8.in
>>>>> index f2fa3b2..7adfdc6 100644
>>>>> --- a/cifs.idmap.8.in
>>>>> +++ b/cifs.idmap.8.in
>>>>> @@ -76,6 +76,9 @@ create =A0 =A0 =A0cifs\&.idmap =A0 =A0 * * @sbi=
ndir@/cifs\&.idmap %k
>>>>> =A0See
>>>>> =A0\fBrequest-key.conf\fR(5)
>>>>> =A0for more info on each field\&.
>>>>> +.SH "NOTES"
>>>>> +.PP
>>>>> +For cifs.idmap to work properly you would need a kernel version =
3.0 or above.
>>>>> =A0.SH "SEE ALSO"
>>>>> =A0.PP
>>>>>
>>>>
>>>> This looks reasonable, but I'm always a bit leery of calling out
>>>> specific versions like this. Some distros (e.g. Red Hat's and Nove=
ll's)
>>>> will backport features from later kernels, so saying you need a 3.=
0
>>>> kernel might be confusing.
>>>>
>>>> We might want to rephrase this with something like "Support for up=
calls
>>>> to cifs.idmap was initially introduced in the 3.0 kernel." It's a
>>>> little more weaselly but it isn't false if someone is working with=
 a
>>>> kernel that has backported this code.
>>>>
>>>> Sound reasonable?
>>>
>>> Yes - also to supplement this data can use the cifs version (displa=
yed
>>> by modinfo) - presumably with wholesale backport of cifs code the
>>> version number could be updated as well.
>>>
>>
>> Except that often, distros pick and choose what new features to
>> backport. FWIW, I typically I don't bother bumping the version numbe=
r
>> in the kmod in RHEL since it's more or less meaningless...
>>
>
> I too don't bump the version number in SLES unless I've to go for a f=
ull
> backport.
>
> Also, I noticed that we no longer document the major features/changes=
 in
> the CHANGES file w.r.t each module version (the last I see is 1.62). =
I
> found that information sometimes useful for e.g. if you want to know
> which features went in between two versions etc.
>
> What do you think about keep the CHANGES file up-to-date? Would it be
> useful?
>
>
> Thanks
> Suresh
>



--=20
Thanks,

Steve
