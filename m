From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] Network and Cluster File System topics
Date: Wed, 31 Jan 2018 15:56:55 -0600
Message-ID: <CAH2r5mszV4owrEmEEcTH59L1Ac2LqKNz4QAZaCLUN=NUvmnAnw@mail.gmail.com>
References: <CAH2r5mvZ6S_k-vfkBAZd3t3OB=jYq1+Gm1WB6Hw+xPQsDjhbtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org,
        CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvZ6S_k-vfkBAZd3t3OB=jYq1+Gm1WB6Hw+xPQsDjhbtA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add progress and requirements in RDMA enablement in fs

And as Ronnie reminded me, File Systems (especially SMB3 smbdirect in
cifs.ko and NFS but probably others, and there is some interest in
whether any of that code could be made common for user space servers
but that may be a topic for a different event) which use RDMA would
benefit from a discussion of the progress in RDMA enablement in file
systems (and whether any of the code could/should be made common).



On Wed, Jan 31, 2018 at 3:22 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I would like to make sure we have at least a brief discussion of
> Network and Cluster File System topics (in the past we have discussed
> how to make delegations/leases more usable, richacl, statx, and a few
> features that would help Samba server).
>
> I can ask around to others on the Samba team as well for their current
> fs pain points (since I am one of the few of us who usually attend).
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
