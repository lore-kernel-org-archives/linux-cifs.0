From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCHv2][SMB3] Add kernel trace support
Date: Fri, 18 May 2018 01:19:30 -0500
Message-ID: <CAH2r5mvW50EzjoU2uXiUC1Z=ShbHpCyYh7GicmwtWOP8cGEXdA@mail.gmail.com>
References: <CAH2r5muobq1gDbGcPE1AYeeKmdFx681=mpCyAZWfSPUa5wLjSQ@mail.gmail.com>
 <1169121702.2774727.1526614091337.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Ronnie Sahlberg <lsahlber@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1169121702.2774727.1526614091337.JavaMail.zimbra@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, May 17, 2018 at 10:28 PM, Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> Very nice.
>
> Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
>
> Possibly change the output from
> pid=6633 tid=0x0 sid=0x0 cmd=0 mid=0
> to
> cmd=0 mid=0 pid=6633 tid=0x0 sid=0x0
>
> just to make it easier for human-searching. I think the cmd will be useful much more often than pid/tid/sid
> and this would make it easier to look for as all cmd= entries will be aligned to the same column.

My instinct is to preserve the consistency by beginning with the the
fields that will be in 90% of the commands: tree id and session id
(tid and sid), which would cause pid to move after sid or after cmd,
but I would prefer to wait on reordering fields and fixing alignment
till we add another set of tracepoints (e.g. in FreeXid, and in
SMB2_open and in the caller of negprot/sessionsetup) - we should then
have a better idea what formatting would make it slightly more
consistent and readable.
