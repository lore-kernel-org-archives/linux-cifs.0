From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH linux-next] cifs: remove unused function cifs_oplock_break_wait
Date: Sun, 10 Aug 2014 14:11:10 -0500
Message-ID: <CAH2r5muS3xz3naupKAVtx3ob+3OUON1uu+QifRLKW4C=mS9mNw@mail.gmail.com>
References: <1405979256-8921-1-git-send-email-vincent.stehle@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, linux-next@vger.kernel.org, samba-technical <samba-technical@lists.samba.org>,
	LKML <linux-kernel@vger.kernel.org>
To: =?UTF-8?Q?Vincent_Stehl=C3=A9?= <vincent.stehle@laposte.net>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1405979256-8921-1-git-send-email-vincent.stehle@laposte.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next

On Mon, Jul 21, 2014 at 4:47 PM, Vincent Stehl=C3=A9
<vincent.stehle@laposte.net> wrote:
> Commit 743162013d40 ("sched: Remove proliferation of wait_on_bit() action
> functions") has removed the call to cifs_oplock_break_wait, making this
> function unused; remove it.
>
> This fixes the following compilation warning:
>
>   fs/cifs/misc.c:578:1: warning: =E2=80=98cifs_oplock_break_wait=E2=80=99=
 defined but not used [-Wunused-function]
>
> Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle@laposte.net>
> Cc: Steve French <sfrench@samba.org>
> ---
>
> Hi,
>
> This can be seen with e.g. linux next-20140721 and arm allmodconfig.
>
> Best regards,
>
> V.
>
>  fs/cifs/misc.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 9a70792..65c2682 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -574,13 +574,6 @@ void cifs_set_oplock_level(struct cifsInodeInfo *cin=
ode, __u32 oplock)
>                 cinode->oplock =3D 0;
>  }
>
> -static int
> -cifs_oplock_break_wait(void *unused)
> -{
> -       schedule();
> -       return signal_pending(current) ? -ERESTARTSYS : 0;
> -}
> -
>  /*
>   * We wait for oplock breaks to be processed before we attempt to perfor=
m
>   * writes.
> --
> 2.0.1
>



--=20
Thanks,

Steve
