From: Pavel Shilovskiy <pshilov@microsoft.com>
Subject: RE: [PATCH AUTOSEL 4.20 40/42] CIFS: Move credit processing to mid
 callbacks for SMB3
Date: Tue, 12 Feb 2019 01:48:36 +0000
Message-ID: <DM5PR21MB0140FF0B60DBF17DF7C676BEB6650@DM5PR21MB0140.namprd21.prod.outlook.com>
References: <20190209184734.125935-1-sashal@kernel.org>
 <20190209184734.125935-40-sashal@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steven French <Steven.French@microsoft.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
To: Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190209184734.125935-40-sashal@kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


Sat, Feb 9 2019, 10:56AM, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Pavel Shilovsky <pshilov@microsoft.com>
>
> [ Upstream commit ee258d79159afed52ca9372aeb9c1a51e89b32ee ]
>
> Currently we account for credits in the thread initiating a request
> and waiting for a response. The demultiplex thread receives the response,
> wakes up the thread and the latter collects credits from the response
> buffer and add them to the server structure on the client. This approach
> is not accurate, because it may race with reconnect events in the
> demultiplex thread which resets the number of credits.
>
> Fix this by moving credit processing to new mid callbacks that collect
> credits granted by the server from the response in the demultiplex thread=
.
>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/cifs/transport.c | 51 ++++++++++++++++++++++++++++++---------------
>  1 file changed, 34 insertions(+), 17 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 4dbf62bb51b2..0dab276eced8 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -781,12 +781,7 @@ cifs_setup_request(struct cifs_ses *ses, struct smb_=
rqst *rqst)
>  }
>
>  static void
> -cifs_noop_callback(struct mid_q_entry *mid)
> -{
> -}
> -
> -static void
> -cifs_cancelled_callback(struct mid_q_entry *mid)
> +cifs_compound_callback(struct mid_q_entry *mid)
>  {
>         struct TCP_Server_Info *server =3D mid->server;
>         unsigned int optype =3D mid->optype;
> @@ -799,10 +794,23 @@ cifs_cancelled_callback(struct mid_q_entry *mid)
>                         cifs_dbg(FYI, "Bad state for cancelled MID\n");
>         }
>
> -       DeleteMidQEntry(mid);
>         add_credits(server, credits_received, optype);
>  }
>
> +static void
> +cifs_compound_last_callback(struct mid_q_entry *mid)
> +{
> +       cifs_compound_callback(mid);
> +       cifs_wake_up_task(mid);
> +}
> +
> +static void
> +cifs_cancelled_callback(struct mid_q_entry *mid)
> +{
> +       cifs_compound_callback(mid);
> +       DeleteMidQEntry(mid);
> +}
> +
>  int
>  compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
>                    const int flags, const int num_rqst, struct smb_rqst *=
rqst,
> @@ -880,11 +888,14 @@ compound_send_recv(const unsigned int xid, struct c=
ifs_ses *ses,
>                 midQ[i]->mid_state =3D MID_REQUEST_SUBMITTED;
>                 midQ[i]->optype =3D optype;
>                 /*
> -                * We don't invoke the callback compounds unless it is th=
e last
> -                * request.
> +                * Invoke callback for every part of the compound chain
> +                * to calculate credits properly. Wake up this thread onl=
y when
> +                * the last element is received.
>                  */
>                 if (i < num_rqst - 1)
> -                       midQ[i]->callback =3D cifs_noop_callback;
> +                       midQ[i]->callback =3D cifs_compound_callback;
> +               else
> +                       midQ[i]->callback =3D cifs_compound_last_callback=
;
>         }
>         cifs_in_send_inc(ses->server);
>         rc =3D smb_send_rqst(ses->server, num_rqst, rqst, flags);
> @@ -898,8 +909,20 @@ compound_send_recv(const unsigned int xid, struct ci=
fs_ses *ses,
>
>         mutex_unlock(&ses->server->srv_mutex);
>
> -       if (rc < 0)
> +       if (rc < 0) {
> +               /* Sending failed for some reason - return credits back *=
/
> +               for (i =3D 0; i < num_rqst; i++)
> +                       add_credits(ses->server, credits[i], optype);
>                 goto out;
> +       }
> +
> +       /*
> +        * At this point the request is passed to the network stack - we =
assume
> +        * that any credits taken from the server structure on the client=
 have
> +        * been spent and we can't return them back. Once we receive resp=
onses
> +        * we will collect credits granted by the server in the mid callb=
acks
> +        * and add those credits to the server structure.
> +        */
>
>         /*
>          * Compounding is never used during session establish.
> @@ -932,11 +955,6 @@ compound_send_recv(const unsigned int xid, struct ci=
fs_ses *ses,
>                 }
>         }
>
> -       for (i =3D 0; i < num_rqst; i++)
> -               if (!cancelled_mid[i] && midQ[i]->resp_buf
> -                   && (midQ[i]->mid_state =3D=3D MID_RESPONSE_RECEIVED))
> -                       credits[i] =3D ses->server->ops->get_credits(midQ=
[i]);
> -
>         for (i =3D 0; i < num_rqst; i++) {
>                 if (rc < 0)
>                         goto out;
> @@ -995,7 +1013,6 @@ out:
>         for (i =3D 0; i < num_rqst; i++) {
>                 if (!cancelled_mid[i])
>                         cifs_delete_mid(midQ[i]);
> -               add_credits(ses->server, credits[i], optype);
>         }
>
>         return rc;
> --
> 2.19.1
>

Please apply the following two patches too:

https://patchwork.ozlabs.org/patch/1030180/
https://patchwork.ozlabs.org/patch/1030181/

The 1st fixes some minor regressions introduces by the proposing patch and =
the 2nd adds the same logic to processing of async responses as the proposi=
ng patch is doing for sync ones.
