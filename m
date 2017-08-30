From: Long Li <longli@microsoft.com>
Subject: RE: [[PATCH v1] 05/37] [CIFS] SMBD: Implement API for upper layer to
 create SMBD transport and establish RDMA connection
Date: Wed, 30 Aug 2017 02:35:54 +0000
Message-ID: <MWHPR21MB0190CB075B933236AF7C5810CE9C0@MWHPR21MB0190.namprd21.prod.outlook.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-6-git-send-email-longli@exchange.microsoft.com>
 <CY4PR21MB018254FE747A2FCEB0650090A08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: Tom Talpey <ttalpey@microsoft.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CY4PR21MB018254FE747A2FCEB0650090A08C0@CY4PR21MB0182.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org



> -----Original Message-----
> From: Tom Talpey
> Sent: Monday, August 14, 2017 12:55 PM
> To: Long Li <longli@microsoft.com>; Steve French <sfrench@samba.org>;
> linux-cifs@vger.kernel.org; samba-technical@lists.samba.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org
> Subject: RE: [[PATCH v1] 05/37] [CIFS] SMBD: Implement API for upper laye=
r
> to create SMBD transport and establish RDMA connection
>=20
> > -----Original Message-----
> > From: linux-cifs-owner@vger.kernel.org [mailto:linux-cifs-
> > owner@vger.kernel.org] On Behalf Of Long Li
> > Sent: Wednesday, August 2, 2017 4:10 PM
> > To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org;
> > samba- technical@lists.samba.org; linux-kernel@vger.kernel.org
> > Cc: Long Li <longli@microsoft.com>
> > Subject: [[PATCH v1] 05/37] [CIFS] SMBD: Implement API for upper layer
> > to create SMBD transport and establish RDMA connection
> >
> > From: Long Li <longli@microsoft.com>
> >
> > Implement the code for connecting to SMBD server. The client and
> > server are connected using RC Queue Pair over RDMA API, which
> > suppports Infiniband, RoCE and iWARP. Upper layer code can call
> > cifs_create_rdma_session to establish a SMBD RDMA connection.
> >
> > +/* Upcall from RDMA CM */
> > +static int cifs_rdma_conn_upcall(
> > +               struct rdma_cm_id *id, struct rdma_cm_event *event) {
> > +       struct cifs_rdma_info *info =3D id->context;
> > +
> > +       log_rdma_event("event=3D%d status=3D%d\n", event->event,
> > + event->status);
> > +
> > +       switch (event->event) {
> > +       case RDMA_CM_EVENT_ADDR_RESOLVED:
> > +       case RDMA_CM_EVENT_ROUTE_RESOLVED:
> > +               info->ri_rc =3D 0;
> > +               complete(&info->ri_done);
> > +               break;
> > +
> > +       case RDMA_CM_EVENT_ADDR_ERROR:
> > +               info->ri_rc =3D -EHOSTUNREACH;
> > +               complete(&info->ri_done);
> > +               break;
> > +
> > +       case RDMA_CM_EVENT_ROUTE_ERROR:
> > +               info->ri_rc =3D -ENETUNREACH;
> > +               complete(&info->ri_done);
> > +               break;
> > +
> > +       case RDMA_CM_EVENT_ESTABLISHED:
> > +       case RDMA_CM_EVENT_CONNECT_ERROR:
> > +       case RDMA_CM_EVENT_UNREACHABLE:
> > +       case RDMA_CM_EVENT_REJECTED:
> > +       case RDMA_CM_EVENT_DEVICE_REMOVAL:
> > +               log_rdma_event("connected event=3D%d\n", event->event);
> > +               info->connect_state =3D event->event;
> > +               break;
> > +
> > +       case RDMA_CM_EVENT_DISCONNECTED:
> > +               break;
> > +
> > +       default:
> > +               break;
> > +       }
> > +
> > +       return 0;
> > +}
>=20
> This code looks a lot like the connection stuff in the NFS/RDMA RPC trans=
port.
> Does your code have the same needs? If so, you might consider moving this
> to a common RDMA handler.

>=20
> > +/* Upcall from RDMA QP */
> > +static void
> > +cifs_rdma_qp_async_error_upcall(struct ib_event *event, void
> > +*context) {
> > +       struct cifs_rdma_info *info =3D context;
> > +       log_rdma_event("%s on device %s info %p\n",
> > +               ib_event_msg(event->event), event->device->name,
> > +info);
> > +
> > +       switch (event->event)
> > +       {
> > +       case IB_EVENT_CQ_ERR:
> > +       case IB_EVENT_QP_FATAL:
> > +       case IB_EVENT_QP_REQ_ERR:
> > +       case IB_EVENT_QP_ACCESS_ERR:
> > +
> > +       default:
> > +               break;
> > +       }
> > +}
>=20
> Ditto. But, what's up with the empty switch(event->event) processing?

I have changed to code to disconnect RDMA connection on QP errors.


>=20
> > +static struct rdma_cm_id* cifs_rdma_create_id(
> > +               struct cifs_rdma_info *info, struct sockaddr *dstaddr)
> > +{
> ...
> > +       log_rdma_event("connecting to IP %pI4 port %d\n",
> > +               &addr_in->sin_addr, ntohs(addr_in->sin_port));
> >... and then...
> > +       if (dstaddr->sa_family =3D=3D AF_INET6)
> > +               sport =3D &((struct sockaddr_in6 *)dstaddr)->sin6_port;
> > +       else
> > +               sport =3D &((struct sockaddr_in *)dstaddr)->sin_port;
> > +
> > +       *sport =3D htons(445);
> ...and
> > +out:
> > +       // try port number 5445 if port 445 doesn't work
> > +       if (*sport =3D=3D htons(445)) {
> > +               *sport =3D htons(5445);
> > +               goto try_again;
> > +       }
>=20
> Suggest rearranging the log_rdma_event() call to reflect reality.
>=20
> The IANA-assigned port for SMB Direct is 5445, and port 445 will be liste=
ning
> on TCP. Should you really be probing that port before 5445?
> I suggest not doing so unconditionally.

This part is reworked in V3 to behave as you suggested.

>=20
> > +struct cifs_rdma_info* cifs_create_rdma_session(
> > +       struct TCP_Server_Info *server, struct sockaddr *dstaddr) {
> > ...
> > +       int max_pending =3D receive_credit_max + send_credit_target;
> >...
> > +       if (max_pending > info->id->device->attrs.max_cqe ||
> > +           max_pending > info->id->device->attrs.max_qp_wr) {
> > +               log_rdma_event("consider lowering receive_credit_max an=
d "
> > +                       "send_credit_target. Possible CQE overrun, devi=
ce "
> > +                       "reporting max_cpe %d max_qp_wr %d\n",
> > +                       info->id->device->attrs.max_cqe,
> > +                       info->id->device->attrs.max_qp_wr);
> > +               goto out2;
> > +       }
>=20
> I don't understand this. Why are you directing both Receive and Send
> completions to the same CQ, won't that make it very hard to manage
> completions and their interrupts? Also, what device(s) have you seen trig=
ger
> this log? CQ's are generally allowed to be quite large.

I have moved them to separate completion queues in V3.

>=20
> > +       conn_param.responder_resources =3D 32;
> > +       if (info->id->device->attrs.max_qp_rd_atom < 32)
> > +               conn_param.responder_resources =3D
> > +                       info->id->device->attrs.max_qp_rd_atom;
> > +       conn_param.retry_count =3D 6;
> > +       conn_param.rnr_retry_count =3D 6;
> > +       conn_param.flow_control =3D 0;
>=20
> These choices warrant explanation. 32 responder resources is on the large
> side for most datacenter networks. And because of SMB Direct's credits, w=
hy
> is RNR_retry not simply zero?
>=20

Those have been fixed. On Mellanox ConnectX3, the attrs.max_qp_rd_atom is 1=
6. So I choose a default value 32 to work with hardware that can potentiall=
y support more responder resources.
