From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/12] cifscreds: cleanup and overhaul of cifscreds utility
Date: Fri, 16 Dec 2011 09:48:30 -0600
Message-ID: <CADT32e+9stCUG+8dcxSh8VTu_5+gW0d_=3ZPqTgrGVd0J+qCcw@mail.gmail.com>
References: <1323972736-15804-1-git-send-email-jlayton@samba.org>
	<CADT32eKaX0Fd6iskcGtUTd0R5i+0SzMwAyjtubk-=RGZ6huB4w@mail.gmail.com>
	<20111215135901.01cfec1b@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111215135901.01cfec1b-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Dec 15, 2011 at 12:59 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> On Thu, 15 Dec 2011 12:20:15 -0600
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Thu, Dec 15, 2011 at 12:12 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wr=
ote:
>> > This patchset is a cleanup and overhaul of the cifscreds utility t=
hat
>> > lives in the cifs-utils tree today. Igor Druzhinin did a wonderful=
 job
>> > on this when he did the original code a couple of years ago, but I=
 did a
>> > rather poor job at the time of communicating what we actually need=
 for
>> > this tool to do. Mea culpa...
>> >
>> > This patch is a second pass at morphing it into a tool that's more=
 like
>> > what we need. I believe with this, I'll be able to roll some kerne=
l
>> > patches that can use the stashed key for establishing sessions.
>> >
>> > I've made a few changes since the last set:
>> >
>> > - combine some of the earlier patches so it's a smaller set
>> >
>> > - I've dropped the patch to make key_search use keyctl_search. I'd=
 still
>> > =A0like to do this differently, but for now it's not possible to d=
o so
>> > =A0and protect the key payload
>> >
>> > The idea here is that we want to be able to allow users to stash t=
heir
>> > NTLM credentials in the kernel, so that it's possible to establish=
 a
>> > session on the fly when that user walks into a multiuser mount.
>>
>> Jeff, is there an initial/earlier document that states exactly how
>> a user can stash NTLM credentials?
>>
>> By NTLM credentials, it is meant that server/domain name/address
>> and corrosponding password etc.?
>>
>
> Correct. The idea here is that this tool stashes a key (or keys) in t=
he
> session keyring with a name like:
>
> =A0 =A0cifscreds:a:<IP Address>
>
> ...or:
>
> =A0 =A0cifscreds:d:<NT Domain Name>
>
> ...that key has a payload that looks like this:
>
> =A0 <username>:<password>
>
> For a multiuser mount, when a user walks into the mount for the first
> time, the kernel can look for a key in the keyring for the right serv=
er,
> or failing that, the right NT domain. It can then get username and
> password info out of the payload to establish a session.
>
> We could also use this to get credentials for the initial mount too,
> but that use-case is less compelling.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Jeff, one of the concerns would be, how to sync up the pasword at the
server and domain.  If the user password at the server changes,
user must make corrosponding changes at the client machine?
Is there a provision to delete or update NTLM credential?
Also, if the same user can use multiple client machines to authenticate=
 to the
same server or domain, should every client machine have a copy of
(the same) NTLM credentials stashed?  And then if password changes,
user must remember to update NTLM credentials on each client machine!
