From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs unable to access shares with read restricted at root level (bso#8950)
Date: Tue, 27 Oct 2015 19:43:46 -0500
Message-ID: <CADT32eJrSGmKW4ksKMNKS1KAYDcN8UxLGPLfm8+Ag9mCxkNdYA@mail.gmail.com>
References: <20151026131817.3a8a3ded@aaptelpc>
	<CADT32eJgrjigh_ezCAJK-ivO-t_yygPEhgwoHKsE-8EdVxKP+Q@mail.gmail.com>
	<20151027105905.0644daf2@aaptelpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151027105905.0644daf2@aaptelpc>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 27, 2015 at 4:59 AM, Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> =
wrote:
> Hi Shirish,
>
> On Mon, 26 Oct 2015 22:04:28 -0500 Shirish Pargaonkar
> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> They are stored in a linked list of struct cifs_rdelem off of
>> superblock where each element of this linked list points to a
>> disconnected dentry.
>
> This list is only used use when we mount with noserverino. It doesn't
> work in both case anyway.

No, that is not the case. I have tested this against a Windows 2012
server and did not mount the shares with noserverino option.
Since we can query info off of disconnected entires, we fill the inodes
which get filled with correct inode info as dentires get spliced.

>
>> > * How do you allocate a new dentry?
>> > * What do d_obtain_alias() and d_splice_dentry() actually do? I've
>> > read the doc strings several times but I still have a hard time
>> > wrapping my head around it.
>>
>> I think the simplistic answer is d_obtain_alias creates a dentry
>> without a parent and d_splice_dentry connects a disconnected dentry
>> to a parent. So let us say you have a a filesystem like /a/b/c/d/e/f
>> where c is not accessible, we would create a disconnected for d (and
>> for all the entries starting d such as e and f)
>> Then when c is accessible and we are trying to reach f, while
>> traversing, for each dentry we would look whether it is disconnected
>> or not and if found (by any of three search routines), splice dentry
>> with c.
>>
>> What kind of setup do you have where the patchset is not working?
>
> Everything is explained on the link I provided. It's the same setup y=
ou
> used I think.
>
>   http://diobla.info/doc/suse-todo#bnc799133

Sorry, missed looking at the link before. yes, the same setup.
I could never get right seutp for Samba server.

>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (=
AG
> N=C3=BCrnberg)
