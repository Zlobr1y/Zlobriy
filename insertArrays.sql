DO
$$
    DECLARE
        _receipt_id           BIGINT      := ?;
        _receipt_date         TIMESTAMP   := ?;
        _reclamation_id       BIGINT      := ?;
        _item_id              VARCHAR[]   := ?;
        _shelf_life_timestamp TIMESTAMP[] := ?;
        _record               record;
    begin
        for _record in
            select data_to_insert.*
            from unnest(_item_id::varchar[],
                        _shelf_life_timestamp::timestamp[]) data_to_insert(ITEM_ID, SHELF_LIFE_TIMESTAMP)
                     left join xrg_shelf_life xsl
                               on xsl.receipt_id = _receipt_id and xsl.reclamation_id = _reclamation_id and
                                  xsl.item_id = data_to_insert.ITEM_ID and
                                  xsl.shelf_life_timestamp = data_to_insert.SHELF_LIFE_TIMESTAMP
            where xsl is null
            loop
                insert into xrg_shelf_life (RECEIPT_ID, RECEIPT_DATE, RECLAMATION_ID, ITEM_ID, SHELF_LIFE_TIMESTAMP)
                values (_receipt_id, _receipt_date, _reclamation_id, _record.item_id, _record.shelf_life_timestamp);
            end loop;
    END
$$;
