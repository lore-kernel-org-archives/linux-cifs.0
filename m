From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount.cifs failed to mount smb2-only shares
Date: Fri, 10 Jun 2011 20:08:51 -0500
Message-ID: <BANLkTinKjNUzjCbHmd5oEBTPcUVxUcLJpg@mail.gmail.com>
References: <BANLkTikE_6VtheOLNJagqMRORF_nMAnE2w@mail.gmail.com>
	<BANLkTinVTEu1ZMmA_HAZMToeOgyXYf4Eqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Kong Li <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinVTEu1ZMmA_HAZMToeOgyXYf4Eqw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jun 10, 2011 at 6:47 PM, Kong Li <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Steve,
>
> Were you referring to
> git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/smb2.git?
> the latest entry is "2010-10-27 =A0 =A0 =A0 =A0 Pavel Shilovsky."

There are newer smb2 support patches which incorporate review comments
and are rebased on current 3.0-rc1 kernel.  See below:

On Thu, Jun 2, 2011 at 4:10 PM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
> Hi!
>
> I applied pending smb2 patches on top of current master branch and
> created branch smb2-dev:
> http://git.etersoft.ru/people/piastry/packages/?p=3Dcifs-2.6.git;a=3D=
shortlog;h=3Drefs/heads/smb2-dev
>
> I also created another branch smb2-dev-experimental and put three
> commits on top of smb2-dev - it makes mount/umount work but after som=
e
> period of time kernel crashes - I am working on fixing this now:
> http://git.etersoft.ru/people/piastry/packages/?p=3Dcifs-2.6.git;a=3D=
shortlog;h=3Drefs/heads/smb2-dev-experimental
>
> Any thoughts/suggestions are welcome!


> On Fri, Jun 10, 2011 at 4:36 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>> Current cifs.ko does not include smb2 support...but pavel recently p=
osted
>> links to his git tree with updated smb2 patches for testing and revi=
ew.
>>
>> On Jun 10, 2011 5:35 PM, "Kong" <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>



--=20
Thanks,

Steve
