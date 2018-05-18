From: Ralph =?utf-8?B?QsO2aG1l?= <slow@samba.org>
Subject: Re: [PATCHv2][SMB3] Add kernel trace support
Date: Fri, 18 May 2018 20:46:32 +0200
Message-ID: <20180518184630.axfa7oq4pewb7foj@kazak>
References: <CAH2r5muobq1gDbGcPE1AYeeKmdFx681=mpCyAZWfSPUa5wLjSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5muobq1gDbGcPE1AYeeKmdFx681=mpCyAZWfSPUa5wLjSQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, May 17, 2018 at 09:36:36PM -0500, Steve French via samba-technical wrote:
> Patch updated with additional tracepoint locations and some formatting
> improvements. There are some obvious additional tracepoints that could
> be added, but this should be a reasonable group to start with.
> 
> From edc02d6f9dc24963d510c7ef59067428d3b082d3 Mon Sep 17 00:00:00 2001
> From: Steve French <stfrench@microsoft.com>
> Date: Thu, 17 May 2018 21:16:55 -0500
> Subject: [PATCH] smb3: Add ftrace tracepoints for improved SMB3 debugging
> 
> Although dmesg logs and wireshark network traces can be
> helpful, being able to dynamically enable/disable tracepoints
> (in this case via the kernel ftrace mechanism) can also be
> helpful in more quickly debugging problems, and more
> selectively tracing the events related to the bug report.
> 
> This patch adds 12 ftrace tracepoints to cifs.ko for SMB3 events
> in some obvious locations.  Subsequent patches will add more
> as needed.
> 
> Example use:
>    trace-cmd record -e cifs
>    <run test case>
>    trace-cmd show

pardon my ignorance, but are these tracepoints usable with other tracing
frameworks like Systemtap?

Last time I checked, Systemtap looked like *the* tool. Is there a generic trace
point infrastructure that tracing tools can consume, so we're not tied to
ftrace?

Thanks!
-slow

-- 
Ralph Boehme, Samba Team       https://samba.org/
Samba Developer, SerNet GmbH   https://sernet.de/en/samba/
GPG Key Fingerprint:           FAE2 C608 8A24 2520 51C5
                               59E4 AA1E 9B71 2639 9E46
