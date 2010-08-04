From: Steve French <smfrench@gmail.com>
Subject: Re: 2.6.36 merge plans
Date: Tue, 3 Aug 2010 23:31:14 -0500
Message-ID: <AANLkTi=_BzaDhRhOZa8tGjfyE2hnguuE5HTH-rqJUw8o@mail.gmail.com>
References: <AANLkTim2UcxAXuR0K8JexGAIq3UoEj1KMH4JMGLnJ72D@mail.gmail.com>
	<20100630141755.4ac97143@tlielax.poochiereds.net>
	<4C2CDD02.2090403@suse.de>
	<AANLkTilEg0zG1DD9fF9T890nFhaqNNeLta1-RAo9iKpM@mail.gmail.com>
	<AANLkTimTjDJeR7ktNcJpPSc-zioHrndPwPxb98HAYgpY@mail.gmail.com>
	<20100701195247.71c3f572@tlielax.poochiereds.net>
	<AANLkTi=X5PyZLdaJj_ikSv7HUNtfmQYhPc50mecx_mMj@mail.gmail.com>
	<20100723191347.1b07cf0c@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman@suse.de>,
	Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-cifs@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100723191347.1b07cf0c@tlielax.poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, Jul 23, 2010 at 6:13 PM, Jeff Layton <jlayton@redhat.com> wrote=
:
> On Fri, 23 Jul 2010 17:19:29 -0500
> Steve French <smfrench@gmail.com> wrote:
>
>> On Thu, Jul 1, 2010 at 6:52 PM, Jeff Layton <jlayton@redhat.com> wro=
te:
>> > On Thu, 1 Jul 2010 16:55:58 -0500
>> > Steve French <smfrench@gmail.com> wrote:
>> >> For =A0 cifs: use CreationTime like an i_generation field
>> >> Seems like a good idea, but what happens if server is unix one wi=
thout
>> >> birth time, eg samba with no xattr support and changes creation t=
ime
>> >> (ie uses last mtime or some such) frequently - e.g. on every writ=
e?
>> >> Would that break your aprroach?
>> >>
>> >
>> > Aye, there's the rub. This makes a ton of sense for windows where =
we
>> > can count on a valid create time. Samba servers may be problematic=
 here,
>> > but with most of them we'll be using unix extensions and you don't=
 get
>> > create times there anyway. The problem may be samba or other
>> > non-windows servers without unix extensions that fake up create ti=
mes.
>> >
>> > We could consider a mount option or something to ignore create tim=
es,
>> > but how to document when it should be used? IMO, fake create times=
 are
>> > really a server bug. Do we hobble servers where this is done corre=
ctly?
>>
>> Jeff,
>> I merged the other patches from your tree, but wanted to think more =
about
>> http://git.kernel.org/?p=3Dlinux/kernel/git/jlayton/linux.git;a=3Dco=
mmit;h=3De5b7e004ed0ccdcf5fd3b1b0aff2a1a45023912b
>> ie the CreationTime i_generation patch and what happens to servers
>> which don't have creation time - presumably e.g. most Samba servers
>> on Linux can't get to creation time. =A0Any additional thoughts on t=
his?
>>
>
> Yeah, the createtime from samba is bogus. But...we'll typically be
> using unix extensions when talking to those servers and the POSIX
> qpathinfo call doesn't return create times. This patch has no effect =
on
> that case.
>
> The only questionable case is talking to samba or another server that
> fakes up create times, *and* unix extensions aren't in use. In that
> case, you'll essentially end up getting a new inode from a cifs_iget
> call whenever the createtime on the file has changed.
>
> Samba (oddly enough) uses the ctime of the file as the createtime. So=
,
> basically that situation will be that you'd end up with a new inode
> from cifs_iget if the metadata of the file has changed.
>
> The situation is very similar to the noserverino case. The main
>
> 1) the inode number wouldn't seem to change when you got the new inod=
e
> in this situation
>
> 2) you'd sometimes match an existing inode, providing its metadata
> hasn't changed since the last time we checked it
>
> I think the impact is minimal. I also think it's preferable to
> unnecessarily spawn a new inode rather than match an existing one tha=
t
> shouldn't be matched.

Jeff,
I think all of your cifs patches are in cifs-2.6.git now - except for
the creation time as i_generation patch which AFAIK is not in your
tree anymore - is that changing?  Any additional feedback on that or
testing with older Samba?



--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
