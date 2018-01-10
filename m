From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Check list_head->next/prev for NULL in __list_del_entry_valid
Date: Wed, 10 Jan 2018 11:03:48 +1100
Message-ID: <20180110000349.14963-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Steve, all,

I am trying to track down a NULL deref that happens during cifs_reconnect().
I don't have the root cause yet but I can mitigate the issue slightly by adding
NULL checks in the list_debug code and avoid the bug I am chasing from
causing a NULL deref to to just become a harmless run-time check.

This is not a fix for the underlying bug, I have yet for find it, but it
will avoif the debugging code from making things worse by causing a crash.

During cifs_reconnect() we are calling
                list_del_init(&mid_entry->qhead);

at this point entry->prev->next is equal to entry and all is good,
but entry->next is NULL which causes the crash in
list_debug.c:__list_del_entry_valid() :
            CHECK_DATA_CORRUPTION(next->prev != entry,

Since __list_del_entry_valid() is used to check that the pointers are all
valid, I think is is acceptable to also add NULL checks here as NULL
is a common value for invalid pointers.
