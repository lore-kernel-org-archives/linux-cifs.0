From: Ira Cooper <ira@wakeful.net>
Subject: Re: Interop Issue: SMB2+ async replies, and the kernel, Samba side
 fix enclosed.
Date: Tue, 23 Feb 2016 23:41:34 -0500
Message-ID: <CAAPGDwL-VsVmPzFFEM5nOAgFCz68a2KHWGAy9KH6ED5PD0vx_Q@mail.gmail.com>
References: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg@mail.gmail.com>
 <56CC591F.30205@samba.org> <1D07D524-6243-4DF5-BBEB-13EE3A2B62AE@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org,
 Samba Technical <samba-technical@lists.samba.org>
To: Steven French <sfrench@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1D07D524-6243-4DF5-BBEB-13EE3A2B62AE@samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

You'll find it easy to reproduce if you:

Set  aio read size =3D 1 in smb.conf.

And modify line 101 in smb2_read.c or close by to be:

    return smbd_smb2_request_pending_queue(req, subreq, 1);

Writing a 1 GB file, umounting the share, and mounting the share again,
then using dd to read it back with rsize and wsize set to 1MB, should do it=
.

We can reproduce it as is with Gluster, I suspect that may be enough to do
it with XFS or other filesystems.

Does anyone know what the windows timeout for sending the interim reply
is?  Barring this bug, sending it when we don't have to is wasteful.

Thanks,

-Ira

On Tue, Feb 23, 2016 at 11:11 PM, Steven French <sfrench@samba.org> wrote:

> Do we have a reproduction scenario?  I don=E2=80=99t remember this one an=
d it
> doesn=E2=80=99t send familiar at all - I use smb3 kernel client to Samba =
every day.
>
> And yes - if we have a bug in the kernel client here let=E2=80=99s fix it=
.
>
>
>
> On Feb 23, 2016, at 7:05 AM, Stefan Metzmacher <metze@samba.org> wrote:
>
> Hi Ira,
>
> If the server sends an interim response, then the real response, the real
> response, is handled by standard_receive3() in the kernel, instead of the
> proper function, and this causes a disconnect.  If there isn't a
> disconnect, I believe the reply will just be discarded if I understand th=
e
> code correctly.  (That is a big if here ;) )
>
> I've written a patch for Samba to stop sending interim replies on SMB2_RE=
AD
> and SMB2_WRITE, when non-compounded to stop the impact of this issue.  We
> may want to add SMB2_CREATE to the list of ops we don't send async replie=
s
> for non-compounded, but I'm not sold either way, I know we CAN go async
> there!  I want some opinions here.
>
> This is not hidden behind a flag because compatibility issues that don't
> impact protocol correctness usually aren't.
>
> Setting req->async_te =3D talloc_new(NULL); is just ugly, though it works=
.
> If you have a cleaner approach, I welcome it.
>
>
> Fix the broken kernel client!
>
> I think this is nothing we should work around in the server.
> The situation might be different if Windows clients would be unhappy,
> but the linux client is more or less under our control and can be fixed.
>
> People hitting this can just use SMB1 until it's fixed.
>
> metze
>
>
>
