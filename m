From: Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 0/3] cifs: Better dependencies
Date: Wed, 25 Jan 2017 16:06:39 +0100
Message-ID: <20170125160639.255cd58e@endymion>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
To: linux-cifs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi all,

This is my attempt to fix and improve the dependencies of cifs.

[PATCH 1/3] cifs: Simplify SMB2 and SMB311 dependencies
[PATCH 2/3] cifs: Only select the required crypto modules
[PATCH 3/3] cifs: Add soft dependencies

I already sent this patch series one year ago, but did not get any
reply, so I am trying again.

Thanks,
-- 
Jean Delvare
SUSE L3 Support
