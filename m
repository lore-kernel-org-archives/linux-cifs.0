From: Tom Talpey <ttalpey@microsoft.com>
Subject: RE: [[PATCH v1] 05/37] [CIFS] SMBD: Implement API for upper layer to
 create SMBD transport and establish RDMA connection
Date: Mon, 14 Aug 2017 19:54:38 +0000
Message-ID: <CY4PR21MB018254FE747A2FCEB0650090A08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-6-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Long Li <longli@microsoft.com>, Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-6-git-send-email-longli@exchange.microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> -----Original Message-----
> From: linux-cifs-owner@vger.kernel.org [mailto:linux-cifs-
> owner@vger.kernel.org] On Behalf Of Long Li
> Sent: Wednesday, August 2, 2017 4:10 PM
> To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org; samba-
> technical@lists.samba.org; linux-kernel@vger.kernel.org
> Cc: Long Li <longli@microsoft.com>
> Subject: [[PATCH v1] 05/37] [CIFS] SMBD: Implement API for upper layer to
> create SMBD transport and establish RDMA connection
>=20
> From: Long Li <longli@microsoft.com>
>=20
> Implement the code for connecting to SMBD server. The client and server a=
re
> connected using RC Queue Pair over RDMA API, which suppports Infiniband,
> RoCE and iWARP. Upper layer code can call cifs_create_rdma_session to
> establish a SMBD RDMA connection.
>=20
> +/* Upcall from RDMA CM */
> +static int cifs_rdma_conn_upcall(
> +               struct rdma_cm_id *id, struct rdma_cm_event *event)
> +{
> +       struct cifs_rdma_info *info =3D id->context;
> +
> +       log_rdma_event("event=3D%d status=3D%d\n", event->event, event->s=
tatus);
> +
> +       switch (event->event) {
> +       case RDMA_CM_EVENT_ADDR_RESOLVED:
> +       case RDMA_CM_EVENT_ROUTE_RESOLVED:
> +               info->ri_rc =3D 0;
> +               complete(&info->ri_done);
> +               break;
> +
> +       case RDMA_CM_EVENT_ADDR_ERROR:
> +               info->ri_rc =3D -EHOSTUNREACH;
> +               complete(&info->ri_done);
> +               break;
> +
> +       case RDMA_CM_EVENT_ROUTE_ERROR:
> +               info->ri_rc =3D -ENETUNREACH;
> +               complete(&info->ri_done);
> +               break;
> +
> +       case RDMA_CM_EVENT_ESTABLISHED:
> +       case RDMA_CM_EVENT_CONNECT_ERROR:
> +       case RDMA_CM_EVENT_UNREACHABLE:
> +       case RDMA_CM_EVENT_REJECTED:
> +       case RDMA_CM_EVENT_DEVICE_REMOVAL:
> +               log_rdma_event("connected event=3D%d\n", event->event);
> +               info->connect_state =3D event->event;
> +               break;
> +
> +       case RDMA_CM_EVENT_DISCONNECTED:
> +               break;
> +
> +       default:
> +               break;
> +       }
> +
> +       return 0;
> +}

This code looks a lot like the connection stuff in the NFS/RDMA RPC transpo=
rt.
Does your code have the same needs? If so, you might consider moving this t=
o
a common RDMA handler.

> +/* Upcall from RDMA QP */
> +static void
> +cifs_rdma_qp_async_error_upcall(struct ib_event *event, void *context)
> +{
> +       struct cifs_rdma_info *info =3D context;
> +       log_rdma_event("%s on device %s info %p\n",
> +               ib_event_msg(event->event), event->device->name, info);
> +
> +       switch (event->event)
> +       {
> +       case IB_EVENT_CQ_ERR:
> +       case IB_EVENT_QP_FATAL:
> +       case IB_EVENT_QP_REQ_ERR:
> +       case IB_EVENT_QP_ACCESS_ERR:
> +
> +       default:
> +               break;
> +       }
> +}

Ditto. But, what's up with the empty switch(event->event) processing?

> +static struct rdma_cm_id* cifs_rdma_create_id(
> +               struct cifs_rdma_info *info, struct sockaddr *dstaddr)
> +{
...
> +       log_rdma_event("connecting to IP %pI4 port %d\n",
> +               &addr_in->sin_addr, ntohs(addr_in->sin_port));
>... and then...
> +       if (dstaddr->sa_family =3D=3D AF_INET6)
> +               sport =3D &((struct sockaddr_in6 *)dstaddr)->sin6_port;
> +       else
> +               sport =3D &((struct sockaddr_in *)dstaddr)->sin_port;
> +
> +       *sport =3D htons(445);
...and
> +out:
> +       // try port number 5445 if port 445 doesn't work
> +       if (*sport =3D=3D htons(445)) {
> +               *sport =3D htons(5445);
> +               goto try_again;
> +       }

Suggest rearranging the log_rdma_event() call to reflect reality.

The IANA-assigned port for SMB Direct is 5445, and port 445 will be
listening on TCP. Should you really be probing that port before 5445?
I suggest not doing so unconditionally.

> +struct cifs_rdma_info* cifs_create_rdma_session(
> +       struct TCP_Server_Info *server, struct sockaddr *dstaddr)
> +{
> ...
> +       int max_pending =3D receive_credit_max + send_credit_target;
>...
> +       if (max_pending > info->id->device->attrs.max_cqe ||
> +           max_pending > info->id->device->attrs.max_qp_wr) {
> +               log_rdma_event("consider lowering receive_credit_max and =
"
> +                       "send_credit_target. Possible CQE overrun, device=
 "
> +                       "reporting max_cpe %d max_qp_wr %d\n",
> +                       info->id->device->attrs.max_cqe,
> +                       info->id->device->attrs.max_qp_wr);
> +               goto out2;
> +       }

I don't understand this. Why are you directing both Receive and Send comple=
tions
to the same CQ, won't that make it very hard to manage completions and thei=
r
interrupts? Also, what device(s) have you seen trigger this log? CQ's are g=
enerally
allowed to be quite large.

> +       conn_param.responder_resources =3D 32;
> +       if (info->id->device->attrs.max_qp_rd_atom < 32)
> +               conn_param.responder_resources =3D
> +                       info->id->device->attrs.max_qp_rd_atom;
> +       conn_param.retry_count =3D 6;
> +       conn_param.rnr_retry_count =3D 6;
> +       conn_param.flow_control =3D 0;

These choices warrant explanation. 32 responder resources is on the large s=
ide for
most datacenter networks. And because of SMB Direct's credits, why is RNR_r=
etry not
simply zero?
